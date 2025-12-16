// lib/models/reply_model.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class ReplyModel {
  final int replyId;
  final int threadId;
  final String userId;
  final String username;
  final String userAvatar;
  final String replyContent;
  final String createdAt;
  final int replyUpvote;
  final int replyDownvote;

  ReplyModel({
    required this.replyId,
    required this.threadId,
    required this.userId,
    required this.username,
    required this.userAvatar,
    required this.replyContent,
    required this.createdAt,
    required this.replyUpvote,
    required this.replyDownvote,
  });

  // Helper untuk mengubah tipe data aman
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // Helper Avatar (Sama seperti ThreadModel)
  static String _getStorageUrl(String bucketName, String path) {
    try {
      return Supabase.instance.client.storage.from(bucketName).getPublicUrl(path);
    } catch (e) {
      return path;
    }
  }

  // Helper Format Tanggal
  static String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      // Format sederhana: DD/MM HH:MM
      return "${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateStr;
    }
  }

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    final userData = json['users'];

    String finalAvatar = 'assets/images/askalot.png';
    String username = 'Unknown';

    if (userData != null) {
      username = userData['username'] ?? 'Unknown';
      if (userData['profile_pic'] != null) {
        String rawPic = userData['profile_pic'];
        if (rawPic.startsWith('http')) {
          finalAvatar = rawPic;
        } else {
          finalAvatar = _getStorageUrl('profile_pic', rawPic);
        }
      }
    }

    return ReplyModel(
      replyId: _toInt(json['reply_id']),
      threadId: _toInt(json['thread_id']),
      userId: json['user_id'].toString(),
      username: username,
      userAvatar: finalAvatar,
      replyContent: json['reply_content'] ?? '',
      createdAt: _formatDate(json['created_at'] ?? DateTime.now().toIso8601String()),
      replyUpvote: _toInt(json['reply_upvote']),
      replyDownvote: _toInt(json['reply_downvote']),
    );
  }
}