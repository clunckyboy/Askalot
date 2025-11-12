import 'package:flutter/material.dart';

// Definisi warna yang digunakan (konsisten dengan screen sebelumnya)
const Color kPrimaryColor = Color(0xFF9596FF); // Ungu
const Color kBackgroundColor = Color(0xFF2B2C35); // Latar belakang gelap
const Color kSecondaryColor = Color(0xFF3D425B); // Latar belakang list item

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  // Daftar topik dan status terpilihnya (false = tidak dipilih)
  final Map<String, bool> topics = {
    'Mobile Programming': false,
    'Gardening': false,
    'Art': false,
    'Computer Science': false,
    'Politics': false,
    'Food': false,
    'Topic Example 1': false,
    'Topic Example 2': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // Menggunakan SingleChildScrollView agar list bisa digulir
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Jarak dari atas dan Status Bar Placeholder Removal
              const SizedBox(height: 50),

              // Bagian Header (Tombol Back dan Tombol Next)
              _buildHeader(),

              const SizedBox(height: 30),

              // Judul Utama
              const Text(
                'Favorite Topics?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontFamily: 'TT Norms Pro',
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 40),

              // Daftar Topik
              ...topics.keys.map((topic) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: _buildTopicItem(topic, topics[topic]!),
                );
              }).toList(),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk Tombol Back dan Next
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tombol Back (di kiri)
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () {
            // Logika kembali
          },
        ),

        // Tombol Next (di kanan, dengan background ungu)
        GestureDetector(
          onTap: () {
            // Logika navigasi ke layar selanjutnya
            final selectedTopics = topics.keys.where((k) => topics[k] == true).toList();
            print('Topik Terpilih: $selectedTopics');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              'Next',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'TT Norms Pro',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk setiap baris Topik yang bisa diklik (Toggle Checkbox)
  Widget _buildTopicItem(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          topics[title] = !isSelected;
        });
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 23),
        decoration: ShapeDecoration(
          color: kSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            // Border Ungu jika terpilih
            side: isSelected
                ? const BorderSide(color: kPrimaryColor, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'TT Norms Pro',
                fontWeight: FontWeight.w500,
              ),
            ),

            // Checkbox Kustom
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isSelected ? kPrimaryColor : Colors.white70,
                  width: 2,
                ),
                color: isSelected ? kPrimaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}