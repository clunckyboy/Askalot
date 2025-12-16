import 'package:askalot/screens/account_screen.dart';
import 'package:askalot/screens/home_screen.dart';
import 'package:askalot/screens/interests_screen.dart';
import 'package:askalot/screens/other_profile_screen.dart';
import 'package:askalot/screens/posting_screen.dart';
import 'package:askalot/screens/signin_screen.dart';
import 'package:askalot/screens/signup_screen.dart';
import 'package:askalot/screens/splash_screen.dart';
import 'package:askalot/widgets/scaffold_with_navbar.dart'; // Kita akan buat ini di langkah 3
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../models/thread_model.dart';
import '../screens/comment_section_screen.dart';
import '../screens/edit_account_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // 1. Splash Screen
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // 2. Auth Flow
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),

    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),

    GoRoute(
      path: '/interests',
      builder: (context, state) {
        // Mengambil data yang dikirim dari Signup Screen
        final userData = state.extra as Map<String, dynamic>;
        return InterestScreen(userData: userData);
      },
    ),

    GoRoute(
      path: '/post',
      builder: (context, state) => const PostingScreen(),
    ),

    GoRoute(
      path: '/edit-account',
      builder: (context, state) {
        return const EditAccountScreen();
      },
    ),

  GoRoute(
    path: '/comments',
    builder: (context, state) => CommentScreen(thread: state.extra as ThreadModel),
  ),

    GoRoute(
      path: '/other-profile',
      builder: (context, state) => OtherProfileScreen(threadData: state.extra as ThreadModel),
    ),

    // 3. Main App Flow (Dengan Bottom Navbar)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Widget wrapper yang berisi BottomNavbar
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Tab 1: Account
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/account',
              builder: (context, state) => const AccountScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);