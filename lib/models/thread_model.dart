import 'package:supabase_flutter/supabase_flutter.dart';

class ThreadModel {
  final int id;
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
  final int upvotes;
  final int downvotes;
  int userVote;

  ThreadModel({
    required this.id,
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
    required this.upvotes,
    required this.downvotes,
    this.userVote = 0
  });

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

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
    try {
      return Supabase.instance.client.storage.from(bucketName).getPublicUrl(path);
    } catch (e) {
      return path;
    }
  }

  factory ThreadModel.fromJson(Map<String, dynamic> json) {
    final userData = json['users'];

    String finalAvatar = 'assets/images/askalot.png';
    if(userData != null && userData['profile_pic'] != null) {
      String rawPic = userData['profile_pic'];
      if (rawPic.startsWith('http')) {
        finalAvatar = rawPic;
      } else {
        finalAvatar = _getStorageUrl('profile_pic', rawPic);
      }
    }

    String? finalMediaUrl;
    if (json['media_url'] != null) {
      String rawMedia = json['media_url'];
      if (rawMedia.startsWith('http')) {
        finalMediaUrl = rawMedia;
      } else {
        finalMediaUrl = _getStorageUrl('posts', rawMedia);
      }
    }

    int parseId = _toInt(json['id']);

    if(parseId == 0) {
      parseId = _toInt(json['thread_id']);
    }

    return ThreadModel(
      id: parseId,
      threadId: json['thread_id'].toString(),
      userId: json['user_id'].toString(),
      username: userData != null ? userData['username'] : 'Unknown User',
      userAvatar: finalAvatar,
      threadContent: json['thread_content'] ?? '',
      mediaUrl: finalMediaUrl,
      mediaType: json['media_type'],
      createdAt: _formatDate(json['created_at'] ?? DateTime.now().toIso8601String()),
      threadUpvote: _toInt(json['thread_upvote']),
      threadDownvote: _toInt(json['thread_downvote']),
      replyCount: _toInt(json['reply_count']),
      upvotes: _toInt(json['thread_upvote']),
      downvotes: _toInt(json['thread_downvote']),
      userVote: 0
    );
  }

  ThreadModel copyWith({int? upvotes, int? downvotes, int? userVote}) {
    return ThreadModel(
      id: this.id,
      threadId: this.threadId,
      userId: this.userId,
      userAvatar: this.userAvatar,
      threadContent: this.threadContent,
      mediaUrl: this.mediaUrl,
      mediaType: this.mediaType,
      threadUpvote: this.threadUpvote,
      threadDownvote: this.threadDownvote,
      replyCount: this.replyCount,
      username: this.username,
      createdAt: this.createdAt,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      userVote: userVote ?? this.userVote,
    );
  }
}