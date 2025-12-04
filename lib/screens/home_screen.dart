import 'package:flutter/material.dart';
import '../models/thread_model.dart'; // Import model
import '../widgets/thread_card.dart'; // Import widget
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> filters = ["Recently", "Hot", "Low Vote", "Oldest"];
  int selectedFilter = 0;

  List<ThreadModel> posts = [];
  bool _isLoading = true;

  Future<void> _fetchThreads() async {
    try {
      final supabase = Supabase.instance.client;

      // Query dengan JOIN ke tabel users
      // Syntax: table_utama!inner(kolom) atau users(username, profile_pic)
      final response = await supabase
          .from('threads')
          .select('*, users(username, profile_pic)')
          .order('created_at', ascending: false); // Urutkan dari terbaru

      final List<dynamic> data = response as List<dynamic>;

      setState(() {
        posts = data.map((json) => ThreadModel.fromJson(json)).toList();
        _isLoading = false;
      });
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
                      onSelected: (_) {
                        setState(() => selectedFilter = index);
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
          // --- LOGIKA UTAMA POST LIST ---
          Expanded(
            child: _isLoading
            // Kondisi 1: Jika Kosong
              ? const Center(child: CircularProgressIndicator())
              : posts.isEmpty
                ? Center(
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
                )
            // Kondisi 2: Jika Ada Data
                : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ThreadCard(
                      thread: post,
                      onFollowPressed: () {
                        print("Follow user: ${post.userId}");
                      },
                    );
                  },
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
