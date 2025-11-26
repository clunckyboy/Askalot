class ThreadModel {
  final String threadId;
  final String userId;
  final String username;
  final String userAvatar;
  final String threadContent;
  final String? mediaUrl;
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
    required this.createdAt,
    required this.threadUpvote,
    required this.threadDownvote,
    required this.replyCount,
  });
}