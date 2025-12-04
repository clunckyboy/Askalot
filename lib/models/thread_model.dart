import 'package:supabase_flutter/supabase_flutter.dart';

class ThreadModel {
  final String threadId;
  final String userId;
  final String username;
  final String userAvatar;
  final String threadContent;
  final String? mediaUrl;
  final String? mediaType;
  final String createdAt;
  final int threadUpvote;
  final int threadDownvote;
  final int replyCount;

  ThreadModel({
    required this.threadId,
    required this.userId,
    required this.username,
    required this.userAvatar,
    required this.threadContent,
    this.mediaUrl,
    this.mediaType,
    required this.createdAt,
    required this.threadUpvote,
    required this.threadDownvote,
    required this.replyCount,
  });

  static String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();

      const List<String> monthNames = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
      ];

      String month = monthNames[date.month - 1];

      String day = date.day.toString();

      return "$month $day";
    } catch (e) {
      return dateStr;
    }
  }

  static String _getStorageUrl(String bucketName, String path) {
    return Supabase.instance.client
        .storage
        .from(bucketName)
        .getPublicUrl(path);
  }


  factory ThreadModel.fromJson(Map<String, dynamic> json) {
    final userData = json['users'];

    // Logika Profile Pic
    String finalAvatar = 'assets/images/askalot.png';
    if(userData != null && userData['profile_pic'] != null) {
      String rawPic = userData['profile_pic'];

      // Cek apakah ini URL dari Google/Luar (diawali http) atau Path Supabase
      if (rawPic.startsWith('http')) {
        finalAvatar = rawPic;
      } else {
        finalAvatar = _getStorageUrl('profile_pic', rawPic);
      }
    }

    // Logika Media
    String? finalMediaUrl;
    if (json['media_url'] != null) {
      String rawMedia = json['media_url'];
      if (rawMedia.startsWith('http')) {
        finalMediaUrl = rawMedia;
      } else {
        finalMediaUrl = _getStorageUrl('posts', rawMedia);
      }
    }

    return ThreadModel(
      threadId: json['thread_id'].toString(),
      userId: json['user_id'].toString(),
      username: userData != null ? userData['username']: 'Unknown User',
      userAvatar: finalAvatar,
      threadContent: json['thread_content'] ?? '',
      mediaUrl: finalMediaUrl,
      mediaType: json['media_type'],
      createdAt: _formatDate(json['created_at']),
      threadUpvote: json['thread_upvote'],
      threadDownvote: json['thread_downvote'],
      replyCount: json['reply_count']
    );
  }
}