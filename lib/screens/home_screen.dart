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

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFF1E1E2C);
    final cardColor = const Color(0xFF2C2C3A);
    final accent = const Color(0xFF7B7FFF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search, size: 28),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Filter Tabs
          SizedBox(
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

          const SizedBox(height: 10),

          // 🔹 Posts List
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
                _buildPostCard(
                  context,
                  username: "larrymustard",
                  date: "5 Aug",
                  avatar: "https://i.pravatar.cc/100?img=2",
                  content: "Hello I’m larry",
                  upvotes: 100,
                  downvotes: 9000,
                  comments: 666,
                ),
                _buildPostCard(
                  context,
                  username: "MyMotherAteFries",
                  date: "12 Sep",
                  avatar: "https://i.pravatar.cc/100?img=3",
                  content:
                  "Is there a way to delete this block in Blender? I’ve spent 5 days trying to figure this out",
                  image:
                  "https://upload.wikimedia.org/wikipedia/commons/3/3a/Blender_3.0_interface_screenshot.png",
                  upvotes: 100,
                  downvotes: 0,
                  comments: 42,
                ),
              ],
            ),
          ),
        ],
      ),

      // 🔹 Floating Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: accent,
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 🔹 Reusable Bottom Navbar
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: _selectedTab,
        onTabSelected: (index) {
          setState(() => _selectedTab = index);
          // You can navigate to other screens here if needed
        },
      ),
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
