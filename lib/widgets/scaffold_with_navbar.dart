import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_navbar.dart'; // Import navbar custom kamu

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: navigationShell.currentIndex,
        onTabSelected: (index) {
          // Navigasi untuk Home (0) dan Account (1 di logika navbar kamu, tapi 2 di router branch)
          // Kita perlu mapping karena tombol tengah kamu unik
          if (index == 0) _goBranch(0); // Home
          if (index == 1) _goBranch(2); // Account (Branch ke-3)
        },
        onCenterButtonPressed: () {
          _goBranch(1); // Posting (Branch ke-2)
        },
      ),
    );
  }
}