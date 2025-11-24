import 'package:flutter/material.dart';
import 'package:askalot/widgets/bottom_navbar.dart'; // Import your reusable navbar

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  final List<String> filters = ["Recently", "Hot", "Low Vote", "Oldest"];
  int selectedFilter = 0;

  void _onCenterButtonPressed() {
    // Logika saat tombol '+' ditekan
    print('Tombol Tengah Ditekan!');
    // Misalnya, tampilkan dialog, bottom sheet, atau navigasi ke layar baru
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 200,
        child: const Center(
          child: Text('Buka Halaman Baru'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final bgColor = const Color(0xFF1E1E2C);
    final cardColor = const Color(0xFF2C2C3A);
    final accent = const Color(0xFF7B7FFF);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2B2D35),
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                _buildPostCard(
                  context,
                  username: "BlueElectric05",
                  date: "11 Sep 2025 - 16:14",
                  avatar: "https://i.pravatar.cc/100?img=1",
                  content:
                  "My cactus wouldn’t stop yelling at me, what should I do?",
                  upvotes: 67,
                  downvotes: 0,
                  comments: 5,
                ),
              ],
            ),
          ),
        ],
      ),

      // // 🔹 Reusable Bottom Navbar
      // bottomNavigationBar: CustomBottomNavbar(
      //   selectedIndex: _selectedTab,
      //   onTabSelected: (index) {
      //     setState(() => _selectedTab = index);
      //     // You can navigate to other screens here if needed
      //   },
      //   onCenterButtonPressed: _onCenterButtonPressed,
      // ),
    );
  }

  // ────────────────────────────────────────────────
  // 🔸 Post Card Builder
  // ────────────────────────────────────────────────
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
