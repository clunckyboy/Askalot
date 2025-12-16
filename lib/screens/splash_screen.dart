import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateNextScreen();
  }

  void _navigateNextScreen() async {
    await Future.delayed(Duration(milliseconds: 1500), (){});
    if(mounted) {
      context.go('/signin'); // Menggunakan GoRouter
    }
  }

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

            const Spacer(flex: 2),

            // Teks "Askalot"
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

            // Logo
            Image.asset(
              'assets/images/askalot.png',
              height: 160,
              fit: BoxFit.contain,
            ),

            // Spacer untuk menciptakan ruang di bawah logo.
            // Flex 3 membuat jarak di bawah lebih besar.
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}