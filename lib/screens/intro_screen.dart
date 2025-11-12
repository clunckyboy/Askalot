import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold sebagai struktur dasar layar.
    return Scaffold(
      body: Padding(
        // Memberikan ruang kosong di sisi kiri dan kanan.
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          // Mengatur agar semua elemen diletakkan di tengah secara vertikal.
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Spacer untuk menciptakan ruang di atas teks (mendorong konten ke bawah).
            // Flex 2 membuat jarak di atas lebih kecil.
            const Spacer(flex: 2),

            // 1. Teks "Askalot"
            const Text(
              'Askalot',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF9596FF),
                fontSize: 80,
                fontFamily: 'TT Norms Pro',
                fontWeight: FontWeight.w900,
              ),
            ),

            // Jarak vertikal 20px antara Teks dan Logo.
            const SizedBox(height: 20),

            // 2. Logo (Pastikan file ada di assets/images/askalot.png)
            Image.asset(
              'assets/images/askalot.png',
              height: 160,
              fit: BoxFit.contain,
            ),

            // Spacer untuk menciptakan ruang di bawah logo.
            // Flex 3 membuat jarak di bawah lebih besar.
            const Spacer(flex: 3),

            // Bilah ungu telah dihapus dari sini.
          ],
        ),
      ),
    );
  }
}