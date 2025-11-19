import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';

// 1. Convert to a StatefulWidget
class OtherProfileScreen extends StatefulWidget {const OtherProfileScreen({super.key});

@override
State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  // 2. Add state variables for the BottomNavbar
  int _selectedTab = 3; // Set initial index, e.g., 3 for the account/profile tab

  // 3. Add the function for the center button press
  void _onCenterButtonPressed() {
    // Add your logic for the center button, e.g., show a create post screen
    print("Center button pressed on Other Profile Screen!");
  }

  // --- Helper Methods (Moved inside the State class) ---

  Widget _buildActionButton(String text, VoidCallback onPressed, {bool isPrimary = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary ? const Color(0xFF8A2BE2) : Colors.grey[700],
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoValue(String text, {bool isBio = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: isBio ? 16 : 18,
          fontStyle: isBio ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }

  Widget _buildInterestChip(String interest) {
    return Chip(
      label: Text(interest, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.grey[800],
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    );
  }


  @override
  Widget build(BuildContext context) {
    // --- MOCK DATA ---
    const String username = "larrymustard";
    const String bio = "Screw my sad chud life";
    const List<String> interests = ["plants", "cactus", "gardening"];
    const String profileImageUrl = "https://cdn-icons-png.flaticon.com/512/1154/1154448.png"; // Placeholder for larrymustard

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Top Profile Section ---
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profileImageUrl),
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Action Button ("Follow") ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildActionButton("Follow", () {
                    // Handle follow logic
                    print("Follow button pressed");
                  }, isPrimary: true),
                  _buildActionButton("Message", () {
                    // Handle message logic
                    print("Message button pressed");
                  }),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(color: Colors.grey),
              const SizedBox(height: 20),


              // --- Profile Details Section ---
              _buildInfoLabel("Bio"),
              const SizedBox(height: 8),
              _buildInfoValue(bio, isBio: true),
              const SizedBox(height: 24),

              _buildInfoLabel("Interests"),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: interests.map((interest) => _buildInterestChip(interest)).toList(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      // 4. Connect the state variables and callbacks to the BottomNavbar
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: _selectedTab,
        onTabSelected: (index) {
          // Use setState to rebuild the widget with the new tab index
          setState(() => _selectedTab = index);
          // You can add navigation logic here if needed
        },
        onCenterButtonPressed: _onCenterButtonPressed,
      ),
    );
  }
}
