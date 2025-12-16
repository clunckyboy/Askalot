import 'package:askalot/screens/account_screen.dart';
import 'package:askalot/screens/home_screen.dart';
import 'package:askalot/screens/interests_screen.dart';
import 'package:askalot/screens/other_profile_screen.dart';
import 'package:askalot/screens/posting_screen.dart';
import 'package:askalot/screens/signin_screen.dart';
import 'package:askalot/screens/signup_screen.dart';
import 'package:askalot/screens/splash_screen.dart';
import 'package:askalot/widgets/scaffold_with_navbar.dart';
import 'package:go_router/go_router.dart';
import '../models/thread_model.dart';
import '../screens/comment_section_screen.dart';
import '../screens/edit_account_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [

    // Splash Screen
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // Sign in
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),

    // Sign up
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),

    // Interests page
    GoRoute(
      path: '/interests',
      builder: (context, state) {
        // Mengambil data yang dikirim dari Signup Screen
        final userData = state.extra as Map<String, dynamic>;
        return InterestScreen(userData: userData);
      },
    ),

    // Post page
    GoRoute(
      path: '/post',
      builder: (context, state) => const PostingScreen(),
    ),

    // Edit account page
    GoRoute(
      path: '/edit-account',
      builder: (context, state) {
        return const EditAccountScreen();
      },
    ),

    // Comment page
    GoRoute(
      path: '/comments',
      builder: (context, state) => CommentScreen(thread: state.extra as ThreadModel),
    ),

    // Other user profile
    GoRoute(
      path: '/other-profile',
      builder: (context, state) => OtherProfileScreen(threadData: state.extra as ThreadModel),
    ),

    // Main App Flow (Bottom Navbar)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Widget wrapper yang berisi BottomNavbar
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Home bar
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Account bar
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