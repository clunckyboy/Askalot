import 'package:flutter/material.dart';
import '../models/thread_model.dart';

class ThreadCard extends StatelessWidget {
  final ThreadModel thread;
  final VoidCallback? onFollowPressed;

  final Function(int voteType) onVote;

  final VoidCallback onCommentPressed;
  final VoidCallback onProfilePressed;

  const ThreadCard({
    super.key,
    required this.thread,
    this.onFollowPressed,
    required this.onVote,
    required this.onCommentPressed,
    required this.onProfilePressed,
  });

  // Menentukan Image Provider (Network vs Asset)
  ImageProvider _getAvatarProvider(String avatarPath) {
    if (avatarPath.startsWith('http')) {
      return NetworkImage(avatarPath);
    } else {
      return AssetImage(avatarPath);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final cardColor = const Color(0xFF2C2C3A);

    final Color upvoteColor = thread.userVote == 1 ? Color(0xFF7B7FFF) : Colors.white70;
    final Color downvoteColor = thread.userVote == -1 ? Colors.redAccent : Colors.white70;

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
          GestureDetector(
            onTap: onProfilePressed,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: _getAvatarProvider(thread.userAvatar),
                  radius: 21,
                  onBackgroundImageError: (exception, stackTrace) {
                    // Fallback jika network error (optional)
                  },
                ),
                const SizedBox(width: 8,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        thread.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        thread.createdAt,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: onFollowPressed ?? (){},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  ),
                  child: Text("Follow"),
                )
              ],
            ),
          ),

          SizedBox(height: 10,),

          // Media Check
          if (thread.mediaUrl != null && thread.mediaUrl!.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                thread.mediaUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) =>
                const Text('Gagal memuat gambar', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],

          SizedBox(height: 13,),

          GestureDetector(
            onTap: onCommentPressed,
            child: Text(
              thread.threadContent,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),

          SizedBox(height: 13,),

          Row(
            children: [
              InkWell(
                onTap: () => onVote(1),
                child: _reaction(Icons.arrow_upward, thread.upvotes.toString(), upvoteColor),
              ),

              const SizedBox(width: 8),

              InkWell(
                onTap: () => onVote(-1),
                child: _reaction(Icons.arrow_downward, thread.downvotes.toString(), downvoteColor),
              ),

              const SizedBox(width: 8),

              InkWell(
                onTap: onCommentPressed, // Panggil callback saat icon ditekan
                child: _reaction(Icons.comment, thread.replyCount.toString(), Colors.white70),
              ),
            ],
          )
        ],
      ),
    );
  }
}
