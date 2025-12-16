import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/thread_model.dart'; // Import model
import '../widgets/thread_card.dart'; // Import widget
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

      // 3. Ambil Data Vote User (Jika user sedang login)
      if (user != null && loadedPosts.isNotEmpty) {
        final threadIds = loadedPosts.map((e) => e.id).toList();

        // Ambil vote user khusus untuk thread-thread yang diload
        final votesResponse = await supabase
            .from('thread_votes')
            .select('thread_id, vote_type')
            .eq('user_id', user.id)
            .inFilter('thread_id', threadIds);

        final Map<int, int> votesMap = {};

        // Map vote ke thread
        // final votesMap = {
        //   for (var v in (votesResponse as List))
        //     (v['thread_id'] as num).toInt(): (v['vote_type'] as num?)?.toInt() ?? 0
        // };

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

      // final List<dynamic> data = response as List<dynamic>;

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
          SnackBar(content: Text('Gagal memuat data: $e')),
        );
      }
    }
  }

  // --- FUNGSI BARU: HANDLE VOTE ---
  Future<void> _handleVote(ThreadModel post, int voteType) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login untuk voting")));
      return;
    }

    // 1. Hitung Logika Optimistic Update (Biar UI instan berubah)
    int newUpvotes = post.upvotes;
    int newDownvotes = post.downvotes;
    int newUserVote = voteType;

    if (post.userVote == voteType) {
      // Toggle OFF (Sudah vote ini, diklik lagi -> Batal)
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

    // 2. Update UI Lokal
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

    // 3. Kirim ke Supabase (Panggil RPC)
    try {
      await supabase.rpc('handle_vote', params: {
        'p_thread_id': post.id,
        'p_vote_type': voteType,
      });
    } catch (e) {
      print("Gagal vote: $e");
      // Revert UI jika gagal (Opsional: panggil _fetchThreads lagi)
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
            // Kondisi 1: Jika Kosong
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
                      // Kondisi 2: Jika Ada Data
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

  Widget _buildPostCard(
      BuildContext context, {
        required String username,
        required String date,
        required String avatar,
        required String content,
        String? image,
        required int upvotes,
        required int downvotes,
        required int comments,
      }) {
    final cardColor = const Color(0xFF2C2C3A);
    final accent = const Color(0xFF7B7FFF);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(avatar), radius: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(date,
                        style:
                        const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
                child: const Text("Follow"),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Post text
          Text(content,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          if (image != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(image),
            ),
          ],
          const SizedBox(height: 10),

          // Reactions
          Row(
            children: [
              _reaction(Icons.arrow_upward, upvotes.toString(), accent),
              const SizedBox(width: 8),
              _reaction(Icons.arrow_downward, downvotes.toString(), Colors.red),
              const SizedBox(width: 8),
              _reaction(Icons.comment, comments.toString(), Colors.white70),
            ],
          )
        ],
      ),
    );
  }

  // 🔸 Reaction Button (Vote / Comment)
  Widget _reaction(IconData icon, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(count,
              style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
