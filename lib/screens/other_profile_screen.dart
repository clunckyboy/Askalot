import 'package:flutter/material.dart';
import '../models/thread_model.dart';

class OtherProfileScreen extends StatefulWidget {
  final ThreadModel threadData;

  const OtherProfileScreen({super.key, required this.threadData});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {

  ImageProvider _getAvatarProvider(String avatarPath){
    if(avatarPath.startsWith('http')) return NetworkImage(avatarPath);
    return AssetImage(avatarPath);
  }

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

    final String username = widget.threadData.username;
    final String profileImageUrl = widget.threadData.userAvatar;
    const String bio = "user's bio";
    const List<String> interests = ["Loading..."];

    return Scaffold(
      backgroundColor: const Color(0xFF2B2D35),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          username,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _getAvatarProvider(profileImageUrl),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildActionButton("Follow", () {
                    print("Follow button pressed");
                  }, isPrimary: true),
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
