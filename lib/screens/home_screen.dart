import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/thread_model.dart';
import '../widgets/thread_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- VARIABEL LAMA (TIDAK BERUBAH) ---
  final List<String> filters = [
    "Recently",
    "Oldest",
    "Highest Upvote",
    "Lowest Upvote",
    "Highest Downvote",
    "Lowest Downvote"
  ];
  int selectedFilter = 0;
  List<ThreadModel> posts = [];
  bool _isLoading = true;

  // --- VARIABEL BARU UNTUK SEARCH & HISTORY ---
  bool _isSearching = false; // Mode search aktif/tidak
  bool _showHistory = false; // Menampilkan widget history atau hasil search
  final TextEditingController _searchController = TextEditingController();

  // Data dummy history (Bisa diganti dengan SharedPreferences nanti)
  List<String> _searchHistory = [
  ];

  Future<void> _fetchThreads() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      String sortColumn = 'created_at';
      bool isAscending = false;

      switch(selectedFilter) {
        case 0: sortColumn = 'created_at'; isAscending = false; break;
        case 1: sortColumn = 'created_at'; isAscending = true; break;
        case 2: sortColumn = 'thread_upvote'; isAscending = false; break;
        case 3: sortColumn = 'thread_upvote'; isAscending = true; break;
        case 4: sortColumn = 'thread_downvote'; isAscending = false; break;
        case 5: sortColumn = 'thread_downvote'; isAscending = true; break;
        default: sortColumn = 'created_at'; isAscending = false;
      }

      var queryBuilder = supabase
          .from('threads')
          .select('*, users(username, profile_pic)');

      // Filter Search
      if (_searchController.text.isNotEmpty) {
        queryBuilder = queryBuilder.ilike('thread_content', '%${_searchController.text}%');
      }

      final response = await queryBuilder.order(sortColumn, ascending: isAscending);

      List<ThreadModel> loadedPosts = (response as List).map((json) => ThreadModel.fromJson(json)).toList();

      if (user != null && loadedPosts.isNotEmpty) {
        final threadIds = loadedPosts.map((e) => e.id).toList();
        final votesResponse = await supabase
            .from('thread_votes')
            .select('thread_id, vote_type')
            .eq('user_id', user.id)
            .inFilter('thread_id', threadIds);

        final Map<int, int> votesMap = {};
        for (var v in (votesResponse as List)) {
          final tId = v['thread_id'] is int ? v['thread_id'] : (v['thread_id'] as num).toInt();
          final vType = v['vote_type'] is int ? v['vote_type'] : (v['vote_type'] as num).toInt();
          votesMap[tId] = vType;
        }

        loadedPosts = loadedPosts.map((post) {
          if (votesMap.containsKey(post.id)) {
            return post.copyWith(userVote: votesMap[post.id]);
          }
          return post;
        }).toList();
      }

      if(mounted){
        setState(() {
          posts = loadedPosts;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching threads: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- LOGIKA BARU: SUBMIT SEARCH ---
  void _submitSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _searchController.text = query;
      _isLoading = true;
      _showHistory = false; // Sembunyikan history, tampilkan hasil

      // Tambahkan ke history jika belum ada
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
      } else {
        // Pindahkan ke paling atas jika sudah ada
        _searchHistory.remove(query);
        _searchHistory.insert(0, query);
      }
    });
    _fetchThreads();
  }

  // --- LOGIKA BARU: HAPUS ITEM HISTORY ---
  void _removeHistoryItem(String item) {
    setState(() {
      _searchHistory.remove(item);
    });
  }

  // Handle vote (Logika Lama)
  Future<void> _handleVote(ThreadModel post, int voteType) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login untuk voting")));
      return;
    }

    int newUpvotes = post.upvotes;
    int newDownvotes = post.downvotes;
    int newUserVote = voteType;

    if (post.userVote == voteType) {
      newUserVote = 0;
      if (voteType == 1) newUpvotes--; else newDownvotes--;
    } else {
      if (voteType == 1) {
        newUpvotes++;
        if (post.userVote == -1) newDownvotes--;
      } else {
        newDownvotes++;
        if (post.userVote == 1) newUpvotes--;
      }
    }

    setState(() {
      final index = posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        posts[index] = post.copyWith(
          upvotes: newUpvotes,
          downvotes: newDownvotes,
          userVote: newUserVote,
        );
      }
    });

    try {
      await supabase.rpc('handle_vote', params: {
        'p_thread_id': post.id,
        'p_vote_type': voteType,
      });
    } catch (e) {
      _fetchThreads();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchThreads();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = const Color(0xFF2C2C3A);
    final accent = const Color(0xFF7B7FFF);
    // Warna background dialog history sesuai gambar
    final historyBgColor = const Color(0xFF383848);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF2C2C3E),
        elevation: 1,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Find similar questions...", // Sesuai gambar
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          autofocus: true,
          onTap: () {
            // Jika tap textfield, munculkan history lagi
            setState(() => _showHistory = true);
          },
          onSubmitted: (value) => _submitSearch(value),
        )
            : const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 13.0),
            child: IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              iconSize: 28,
              onPressed: () {
                setState(() {
                  if (_isSearching) {
                    // Close Search
                    _isSearching = false;
                    _showHistory = false;
                    _searchController.clear();
                    _isLoading = true;
                    _fetchThreads(); // Refresh data original
                  } else {
                    // Open Search
                    _isSearching = true;
                    _showHistory = true; // Langsung buka history
                  }
                });
              },
            ),
          ),
        ],
      ),

      // Stack digunakan agar History Widget bisa "mengambang" di atas konten
      body: Stack(
        children: [
          // 1. KONTEN UTAMA (HOME SCREEN ASLI)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedFilter == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          selected: isSelected,
                          label: Text(filters[index]),
                          selectedColor: accent,
                          onSelected: (selected) {
                            setState(() {
                              selectedFilter = index;
                              _isLoading = true;
                            });
                            _fetchThreads();
                          },
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          backgroundColor: cardColor,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                  onRefresh: _fetchThreads,
                  color: accent,
                  backgroundColor: cardColor,
                  child: posts.isEmpty
                      ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_rounded, size: 80, color: Colors.grey[700]),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? "No result found for \"${_searchController.text}\""
                                  : "No posts yet",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return ThreadCard(
                        thread: post,
                        onFollowPressed: () {},
                        onVote: (voteType) => _handleVote(post, voteType),
                        onCommentPressed: (){
                          context.push('/comments', extra: post);
                        },
                        onProfilePressed: (){
                          final currentUserId = Supabase.instance.client.auth.currentUser?.id;
                          if(currentUserId == post.userId){
                            context.go('/account');
                          } else {
                            context.push('/other-profile', extra: post);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // 2. WIDGET SEARCH HISTORY (OVERLAY)
          if (_isSearching && _showHistory)
            Container(
              color: Colors.black54,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: historyBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Agar tingginya menyesuaikan isi
                      children: _searchHistory.map((historyItem) {
                        return Column(
                          children: [
                            ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                              title: Text(
                                historyItem,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.highlight_off, color: Colors.white70),
                                onPressed: () => _removeHistoryItem(historyItem),
                              ),
                              onTap: () => _submitSearch(historyItem),
                            ),
                            if (historyItem != _searchHistory.last)
                              Divider(height: 1, color: Colors.white.withOpacity(0.1)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  // Area kosong di bawah untuk menutup history jika diklik
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showHistory = false;
                        });
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}