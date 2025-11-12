import 'package:flutter/material.dart';

// Definisi warna yang digunakan
const Color kPrimaryColor = Color(0xFF9596FF); // Ungu
const Color kBackgroundColor = Color(0xFF2B2D35); // Latar belakang gelap

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // Menggunakan ListView agar layar dapat digulir jika keyboard muncul
      body: SingleChildScrollView(
        child: Padding(
          // Padding di sisi kiri, kanan, dan atas
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Jarak dari atas (menggantikan status bar palsu)
              const SizedBox(height: 50),

              // Tombol Kembali (sesuai desain Figma Anda di kiri atas)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    // Logika kembali ke halaman sebelumnya (misal: Navigator.pop(context))
                  },
                ),
              ),

              const SizedBox(height: 20),

              // GAMBAR LOGO (Diperbarui untuk menggunakan Image.asset)
              Center(
                child: Image.asset(
                  'assets/images/askalot.png', // Sesuaikan dengan path logo Anda
                  width: 120,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 30),

              // Judul
              const Text(
                'Create your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontFamily: 'TT Norms Pro',
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 40),

              // Formulir Input
              _buildInputSection(title: 'Username'),
              const SizedBox(height: 18),
              _buildInputSection(title: 'Email'),
              const SizedBox(height: 18),
              _buildInputSection(title: 'Password', isPassword: true),
              const SizedBox(height: 18),
              _buildInputSection(title: 'Confirm Password', isPassword: true),

              const SizedBox(height: 40),

              // Tombol Sign Up
              ElevatedButton(
                onPressed: () {
                  // Logika Sign Up di sini
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 49),
                  backgroundColor: kPrimaryColor, // Warna ungu
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: 'TT Norms Pro',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi pembangun widget untuk input field (membuat kode lebih rapi)
  Widget _buildInputSection({required String title, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'TT Norms Pro',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            filled: true,
            // Warna latar input yang lebih transparan
            fillColor: kBackgroundColor.withOpacity(0.3),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kPrimaryColor, width: 2), // Fokus border warna ungu
            ),
          ),
        ),
      ],
    );
  }
}