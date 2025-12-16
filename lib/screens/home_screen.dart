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

  Future<void> _fetchThreads() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      String sortColumn = 'created_at';
      bool isAscending = false;

      switch(selectedFilter) {
        case 0: // Recently
          sortColumn = 'created_at';
          isAscending = false;
          break;
        case 1: // Oldest
          sortColumn = 'created_at';
          isAscending = true;
          break;
        case 2: // Highest upvote
          sortColumn = 'thread_upvote';
          isAscending = false;
          break;
        case 3: // Lowest upvote
          sortColumn = 'thread_upvote';
          isAscending = true;
          break;
        case 4: // Highest downvote
          sortColumn = 'thread_downvote';
          isAscending = false;
          break;
        case 5: // Lowest downvote
          sortColumn = 'thread_downvote';
          isAscending = true;
          break;
        default:
          sortColumn = 'created_at';
          isAscending = false;
      }

      final response = await supabase
          .from('threads')
          .select('*, users(username, profile_pic)')
          .order(sortColumn, ascending: isAscending);

      List<ThreadModel> loadedPosts = (response as List).map((json) => ThreadModel.fromJson(json)).toList();

      // Ambil Data Vote User (Jika user sedang login)
      if (user != null && loadedPosts.isNotEmpty) {
        final threadIds = loadedPosts.map((e) => e.id).toList();

        // Ambil vote user khusus untuk thread-thread yang diload
        final votesResponse = await supabase
            .from('thread_votes')
            .select('thread_id, vote_type')
            .eq('user_id', user.id)
            .inFilter('thread_id', threadIds);

        final Map<int, int> votesMap = {};

        for (var v in (votesResponse as List)) {
          // Ambil data dengan aman
          final tId = v['thread_id'];
          final vType = v['vote_type'];

          // Konversi manual agar aman dari null
          int safeThreadId = 0;
          if (tId is int) safeThreadId = tId;
          else if (tId is num) safeThreadId = tId.toInt();

          int safeVoteType = 0;
          if (vType is int) safeVoteType = vType;
          else if (vType is num) safeVoteType = vType.toInt();

          votesMap[safeThreadId] = safeVoteType;
        }

        // Update list post dengan status vote
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      }
    }
  }

  // Handle vote
  Future<void> _handleVote(ThreadModel post, int voteType) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login untuk voting")));
      return;
    }

    // Logika UI instan berubah
    int newUpvotes = post.upvotes;
    int newDownvotes = post.downvotes;
    int newUserVote = voteType;

    if (post.userVote == voteType) {
      // Toggle Off
      newUserVote = 0;
      if (voteType == 1) newUpvotes--;
      else newDownvotes--;
    } else {
      // Vote Baru atau Ganti Vote
      if (voteType == 1) {
        newUpvotes++;
        if (post.userVote == -1) newDownvotes--; // Kalau sebelumnya down, kurangi down
      } else {
        newDownvotes++;
        if (post.userVote == 1) newUpvotes--; // Kalau sebelumnya up, kurangi up
      }
    }

    // Update UI Lokal
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

    // Kirim ke Supabase
    try {
      await supabase.rpc('handle_vote', params: {
        'p_thread_id': post.id,
        'p_vote_type': voteType,
      });
    } catch (e) {
      print("Gagal vote: $e");
      // Revert UI jika gagal
      _fetchThreads();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchThreads();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = const Color(0xFF2C2C3A);
    final accent = const Color(0xFF7B7FFF);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF2C2C3E),
        elevation: 1,
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 13.0),
            child: IconButton(
              icon: Icon(Icons.search),
              iconSize: 28,
              onPressed: (){},
            ),
          ),
        ],
      ),

      body: Column(
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
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: cardColor,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Posts
          Expanded(
            child: _isLoading
            // Kondisi 1, Jika Kosong
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _fetchThreads,
                  color: accent,
                  backgroundColor: cardColor,
                  child: posts.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              // Agar konten berada di tengah layar secara vertikal
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inbox_rounded, size: 80, color: Colors.grey[700]),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No posts yet",
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
                      // Kondisi 2, Jika Ada Data
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return ThreadCard(
                              thread: post,
                              onFollowPressed: () {
                                print("Follow user: ${post.userId}");
                              },
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
    );
  }
}
