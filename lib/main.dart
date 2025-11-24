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
import 'package:askalot/config/router.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://vxjwjyycklgdxdeyqoax.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ4andqeXlja2xnZHhkZXlxb2F4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1NDMwOTUsImV4cCI6MjA3OTExOTA5NX0.lhcZl2DaLYlqu-lipVvaDIVG2UPVgrNrtz8vRRhxR-w'
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          surfaceTintColor: Color(0xFF2B2D35),
        ),
        scaffoldBackgroundColor: Color(0xFF2B2D35),
        primaryColor: Color(0xFF7A6BFF),
        hintColor: Colors.grey[400],
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2B2D35),
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
    );
  }
}

