import 'package:flutter/material.dart';

class OtherProfileScreen extends StatelessWidget {
  // In a real app, you would pass a userId and fetch the user's data.
  // For this example, we'll pass the data directly.
  const OtherProfileScreen({super.key});

  // Helper method to build reusable action buttons
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

  // Helper method for category labels like "Profile" and "Account"
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

  // Helper method for displaying the user's information values
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

  // Helper method to create interest chips
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
    // This data would be fetched based on a userId
    const String username = "larrymustard";
    const String bio = "Screw my sad chud life";
    const List<String> interests = ["plants", "cactus", "gardening"];
    const String profileImageUrl = "https://cdn-icons-png.flaticon.com/512/147/147144.png"; // Placeholder

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
    );
  }
}
