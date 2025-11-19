import 'package:askalot/screens/account_screen.dart';
import 'package:askalot/screens/comment_section_screen.dart';
import 'package:askalot/screens/edit_account_screen.dart';
import 'package:askalot/screens/home_screen.dart';
import 'package:askalot/screens/interests_screen.dart';
import 'package:askalot/screens/other_profile_screen.dart';
import 'package:askalot/screens/posting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'screens/signin_screen.dart';
import 'package:askalot/screens/splash_screen.dart';
import 'package:askalot/screens/signup_screen.dart';
import 'package:askalot/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          surfaceTintColor: Color(0xFF2B2D35),
        ),
        scaffoldBackgroundColor: Color(0xFF23232F),
        primaryColor: Color(0xFF7A6BFF),
        hintColor: Colors.grey[400],
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2C2C3E),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Color(0xFF7A6BFF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF7A6BFF))
          ),
        ),
      ),
      home: CommentScreen(),
    );
  }
}

