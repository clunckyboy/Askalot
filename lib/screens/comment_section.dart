import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart'; // 1. Import your bottom_navbar widget

// 2. Convert the main widget to a StatefulWidget
class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  // 3. Add state variables for the BottomNavbar
  int _selectedTab = 0; // Set initial index, e.g., 0 for home

  void _onCenterButtonPressed() {
    // Add your logic for the center button, e.g., show a create post screen
    print("Center button pressed on Comment Screen!");
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for the post and comments, similar to the image
    final post = {
      'author': 'BlueElectric05',
      'timestamp': '11 Sep',
      'text': "My cactus wouldn't stop yelling at me, what should I do?",
      'tags': ['#plants', '#cactus', '#gardening'],
      'upvotes': 67,
      'commentsCount': 5,
    };

    final comments = [
      Comment(
        author: 'larrymustard',
        avatarUrl: 'https://cdn-icons-png.flaticon.com/512/1154/1154448.png', // Placeholder
        text: 'Delete that thing from existence',
        timestamp: '11 Sep',
        upvotes: 67,
        replies: [
          Comment(
              author: 'BlueElectric05',
              avatarUrl: 'https://cdn-icons-png.flaticon.com/512/147/147144.png', // Placeholder
              text: 'Tried but it keeps resisting.....',
              timestamp: '11 Sep',
              upvotes: 40,
              replies: [
                Comment(
                  author: 'larrymustard',
                  avatarUrl: 'https://cdn-icons-png.flaticon.com/512/1154/1154448.png', // Placeholder
                  text: 'use holy water',
                  timestamp: '11 Sep',
                  upvotes: 40,
                ),
              ]),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF2C2F33), // Dark theme background
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2F33),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Comments', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              /* Search functionality */
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12.0),
              children: [
                // --- Original Post Widget ---
                _PostWidget(post: post),
                const SizedBox(height: 20),
                // --- Comments List ---
                ...comments.map((comment) => CommentThread(comment: comment)).toList(),
              ],
            ),
          ),
          // --- Add Comment Input Field ---
          _AddCommentInput(),
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

// --- Reusable Widget for the Original Post ---
class _PostWidget extends StatelessWidget {
  final Map<String, dynamic> post;
  const _PostWidget({required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              // In a real app, use Image.network(avatarUrl)
              backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147144.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post['author'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(post['timestamp'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Follow'),
            )
          ],
        ),
        const SizedBox(height: 15),
        Text(post['text'], style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: (post['tags'] as List<String>)
              .map((tag) => Chip(
            label: Text(tag, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.grey.shade700,
            padding: EdgeInsets.zero,
          ))
              .toList(),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionButton(Icons.arrow_upward, post['upvotes'].toString(), Colors.green),
            _buildActionButton(Icons.arrow_downward, '0', Colors.grey),
            _buildActionButton(Icons.comment, post['commentsCount'].toString(), Colors.grey),
            _buildActionButton(Icons.share, '', Colors.grey),
          ],
        ),
        const Divider(color: Colors.grey, height: 20),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          if (text.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(color: Colors.white)),
          ]
        ],
      ),
    );
  }
}

// --- Mock Data Model ---
class Comment {
  final String author;
  final String avatarUrl;
  final String text;
  final String timestamp;
  final int upvotes;
  final List<Comment> replies;
  bool isExpanded;

  Comment({
    required this.author,
    required this.avatarUrl,
    required this.text,
    required this.timestamp,
    this.upvotes = 0,
    this.replies = const [],
    this.isExpanded = true,
  });
}

// --- Reusable Widget for a Comment and its Replies (Thread) ---
class CommentThread extends StatefulWidget {
  final Comment comment;
  final int depth;

  const CommentThread({super.key, required this.comment, this.depth = 0});

  @override
  State<CommentThread> createState() => _CommentThreadState();
}

class _CommentThreadState extends State<CommentThread> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.comment.isExpanded;
  }

  void _toggleReplies() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Indent replies
      padding: EdgeInsets.only(left: widget.depth * 12.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Vertical line for threading ---
            if (widget.depth > 0)
              SizedBox(
                width: 20,
                child: CustomPaint(
                  painter: _ThreadLinePainter(),
                ),
              ),
            // --- Comment Content ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CommentHeader(
                    author: widget.comment.author,
                    avatarUrl: widget.comment.avatarUrl,
                    timestamp: widget.comment.timestamp,
                    isExpanded: _isExpanded,
                    onToggle: _toggleReplies,
                  ),
                  // --- The actual comment text and actions ---
                  if (_isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0), // Align with header text
                      child: _CommentBody(
                        text: widget.comment.text,
                        upvotes: widget.comment.upvotes,
                      ),
                    ),
                  // --- Replies (Recursive) ---
                  if (_isExpanded)
                    ...widget.comment.replies.map((reply) => CommentThread(
                      comment: reply,
                      depth: widget.depth + 1,
                    )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper widget for the comment's header (avatar, name, etc.) ---
class _CommentHeader extends StatelessWidget {
  final String author;
  final String avatarUrl;
  final String timestamp;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _CommentHeader({
    required this.author,
    required this.avatarUrl,
    required this.timestamp,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: CircleAvatar(backgroundImage: NetworkImage(avatarUrl), radius: 14),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onToggle,
          child: Text(
            author,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Text(timestamp, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const Spacer(),
        // This is the collapse button from the image
        GestureDetector(
          onTap: onToggle,
          child: Icon(
            isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ],
    );
  }
}

// --- Helper widget for the comment's body (text, actions) ---
class _CommentBody extends StatelessWidget {
  final String text;
  final int upvotes;

  const _CommentBody({required this.text, required this.upvotes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Reply'),
            ),
            const Spacer(),
            const Icon(Icons.arrow_upward, color: Colors.grey),
            const SizedBox(width: 5),
            Text('$upvotes', style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 15),
            const Icon(Icons.arrow_downward, color: Colors.grey),
            const SizedBox(width: 5),
            const Text('0', style: const TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// --- Painter for the vertical thread line ---
class _ThreadLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 1.5;
    // Draws a vertical line from top-center to bottom-center
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// --- Widget for the "Add a comment" input field at the bottom ---
class _AddCommentInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color(0xFF23272A),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147144.png'), // Current user avatar
            radius: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add a comment',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade800,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    /* Send comment */
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
