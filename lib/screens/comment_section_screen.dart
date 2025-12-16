import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';
import '../models/thread_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/reply_model.dart';

class CommentScreen extends StatefulWidget {

  final ThreadModel thread;
  const CommentScreen({super.key, required this.thread});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  int _selectedTab = 0;
  bool _isLoading = true;
  List<ReplyModel> _replies = [];

  final TextEditingController _commentController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _fetchComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchComments() async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('replies')
          .select('*, users(username, profile_pic)')
          .eq('thread_id', widget.thread.id)
          .order('created_at', ascending: true);

      final List<dynamic> data = response as List<dynamic>;

      if (mounted) {
        setState(() {
          _replies = data.map((json) => ReplyModel.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching comments: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    // Bersihkan text field biar UX enak (Optimistic feel)
    _commentController.clear();
    FocusScope.of(context).unfocus(); // Tutup keyboard

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) return;

      // Insert ke tabel replies
      await supabase.from('replies').insert({
        'thread_id': widget.thread.id,
        'user_id': user.id,
        'reply_content': content,
        'reply_upvote': 0, // Default value (jika DB belum set default)
        'reply_downvote': 0,
      });

      // Refresh list komentar
      _fetchComments();

      // Opsional: Update reply count di tabel threads (bisa pakai RPC atau trigger di DB)

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal kirim komentar: $e")));
    }
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color(0xFF23272A),
      child: Row(
        children: [
          // Avatar user yang sedang login (Bisa diambil dari Supabase auth metadata atau fetch profile)
          const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
            radius: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _commentController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade800,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF7A6BFF)),
                  onPressed: _addComment, // Panggil fungsi Add Comment
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onCenterButtonPressed() {
    print("Center button pressed on Comment Screen!");
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: const Color(0xFF2B2D35), // Dark theme background

      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2F33),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Comments', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),

      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  padding: const EdgeInsets.all(12.0),
                  children: [
                    _PostWidget(thread: widget.thread),

                    const Divider(color: Colors.grey, height: 30,),

                    if(_replies.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Column(
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey,),
                            SizedBox(height: 10,),
                            Text(
                              "No comments yet.\nBe the first to reply!",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            )
                          ],
                        ),
                      )
                    else
                      ..._replies.map((reply) => _ReplyItem(reply: reply)).toList(),
                  ],
                ),
          ),
          _buildInputArea(),
        ],
      ),
      // 4. Connect the state variables and callbacks to the BottomNavbar
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: _selectedTab,
        onTabSelected: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        onCenterButtonPressed: _onCenterButtonPressed,
      ),
    );
  }

}

class _PostWidget extends StatelessWidget {
  final ThreadModel thread;
  const _PostWidget({required this.thread});

  ImageProvider _getAvatarProvider(String avatarPath) {
    if (avatarPath.startsWith('http')) return NetworkImage(avatarPath);
    return AssetImage(avatarPath);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: _getAvatarProvider(thread.userAvatar),
              radius: 20,
            ),

            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(thread.username, style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
                Text(thread.createdAt,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),

        const SizedBox(height: 15),
        Text(thread.threadContent,
            style: const TextStyle(color: Colors.white, fontSize: 16)),

        if (thread.mediaUrl != null) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(thread.mediaUrl!, height: 200,
                width: double.infinity,
                fit: BoxFit.cover),
          )
        ],
      ],
    );
  }
}

class _ReplyItem extends StatelessWidget {
  final ReplyModel reply;
  const _ReplyItem({required this.reply});

  ImageProvider _getAvatarProvider(String avatarPath) {
    if (avatarPath.startsWith('http')) return NetworkImage(avatarPath);
    return AssetImage(avatarPath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: _getAvatarProvider(reply.userAvatar),
            radius: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Nama & Waktu
                Row(
                  children: [
                    Text(
                      reply.username,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      reply.createdAt,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Isi Komentar
                Text(
                  reply.replyContent,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 8),
                // Tombol Reaksi Kecil
                Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 4),
                    Text('${reply.replyUpvote}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    const SizedBox(width: 16),
                    Icon(Icons.arrow_downward, color: Colors.grey[600], size: 16),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}