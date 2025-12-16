import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_navbar.dart';

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
          _goBranch(index);
        },
        onCenterButtonPressed: () {
          context.push('/post');
        },
      ),
    );
  }
}