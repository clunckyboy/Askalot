import 'package:flutter/material.dart';
import 'package:askalot/widgets/topic_selection_item.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryColor = Color(0xFF7A6BFF); // Ungu
const Color kBackgroundColor = Color(0xFF2B2C35); // Latar belakang gelap
const Color kSecondaryColor = Color(0xFF3D425B); // Latar belakang list item

class InterestScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const InterestScreen({super.key, required this.userData});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {

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

  bool _isSubmitting = false;

  Future<void> _submitData() async {
    setState(() => _isSubmitting = true);

    try {
      final supabase = Supabase.instance.client;

      // Ambil topik yang dipilih
      final selectedTopics = topics.keys.where((k) => topics[k] == true).toList();

      // Gabungkan data user (dari Sign up) + data interest
      final dataToInsert = {
        'username': widget.userData['username'],
        'email': widget.userData['email'],
        'password': widget.userData['password'],
        'fav_topics': selectedTopics, // Pastikan kolom di DB tipe array/jsonb
      };

      // Insert ke table 'users'
      await supabase.from('users').insert(dataToInsert);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Akun berhasil dibuat! Silakan Login.")),
        );
        // Arahkan ke Login
        context.go('/signin');
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal membuat akun: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // Hitung jumlah topik yang terpilih
  int get selectedCount => topics.values.where((v) => v).length;

  // Widget untuk Tombol Back dan Next
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => context.pop(),
        ),

        GestureDetector(
          onTap: (selectedCount > 0 && !_isSubmitting) ? _submitData : null,
          child: _isSubmitting
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Opacity(
              opacity: selectedCount > 0 ? 1.0 : 0.5, // Visualisasi dinonaktifkan
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Jarak dari atas
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

              // Daftar Topik - Menggunakan Widget Kustom TopicSelectionItem
              ...topics.keys.map((topic) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TopicSelectionItem(
                    title: topic,
                    isSelected: topics[topic]!,
                    onToggle: () {
                      setState(() {
                        // Logika toggle status di sini
                        topics[topic] = !topics[topic]!;
                      });
                    },
                  ),
                );
              }).toList(),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }


}