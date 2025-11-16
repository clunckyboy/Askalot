import 'package:askalot/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';

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

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
          SignInScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),


      )
    );
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