class Thread {
  final int thread_id;
  final int user_id;
  final String thread_content;
  final String? media_url;
  final String? media_type;
  final DateTime created_at;
  final int thread_upvote;
  final int thread_downvote;
  final int reply_count;

  Thread({
    required this.thread_id,
    required this.user_id,
    required this.thread_content,
    this.media_type,
    this.media_url,
    required this.created_at,
    required this.thread_upvote,
    required this.thread_downvote,
    required this.reply_count,
  });
}