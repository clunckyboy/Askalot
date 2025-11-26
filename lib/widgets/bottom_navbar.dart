import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onCenterButtonPressed; // Ditambahkan untuk tombol '+'

  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color activePillColor; // Warna pil saat aktif
  final Color centerButtonColor; // Warna tombol '+'

  const CustomBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onCenterButtonPressed, // Tombol '+' wajib punya fungsi
    this.backgroundColor = const Color(0xFF2B2D35), // Latar belakang bar
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.white54,
    this.activePillColor = const Color(0xFF3D425B), // Latar belakang pil
    this.centerButtonColor = const Color(0xFF8B5CF6), // Warna ungu tombol '+'
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: backgroundColor,
      // Hapus 'shape' dan 'notchMargin' karena barnya datar
      elevation: 12,
      shadowColor: Colors.black,
      child: Padding(
        // Padding disesuaikan agar pas
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Item 0: Home - menggunakan Expanded agar sama lebar
            Expanded(
              child: _navItem(Icons.home_filled, "Home", 0),
            ),

            // Spacer untuk memberikan jarak yang sama
            const SizedBox(width: 30),

            // Item 1: Tombol '+' kustom
            _buildCenterButton(),

            // Spacer untuk memberikan jarak yang sama
            const SizedBox(width: 30),

            // Item 2: Account - menggunakan Expanded agar sama lebar
            Expanded(
              child: _navItem(Icons.person, "Account", 1),
            ),

          ],
        ),
      ),
    );
  }

  // Widget untuk tombol '+' di tengah
  Widget _buildCenterButton() {
    return SizedBox(
      width: 90, // Atur lebar
      height: 60, // Atur tinggi
      child: ElevatedButton(
        onPressed: onCenterButtonPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: centerButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corner
          ),
          padding: EdgeInsets.zero, // Hapus padding default
        ),
        child: Icon(Icons.add, color: activeColor, size: 30),
      ),
    );
  }

  // Widget untuk item navigasi (Home & Account)
  Widget _navItem(IconData icon, String label, int index) {
    final bool isSelected = selectedIndex == index;

    // Animasi sederhana untuk item aktif/tidak aktif
    return GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container Pil hanya muncul jika Selected
          Container(
            width: 70,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? activePillColor : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 26,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : inactiveColor,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );

    // // Tampilan untuk item TIDAK AKTIF
    // Widget inactiveItem = Column(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     Icon(icon, size: 28, color: inactiveColor),
    //     const SizedBox(height: 3),
    //     Text(
    //       label,
    //       style: TextStyle(
    //         color: inactiveColor,
    //         fontSize: 13,
    //       ),
    //     ),
    //   ],
    // );
    //
    // // Tampilan untuk item AKTIF (dengan pil)
    // Widget activeItem = Container(
    //   // padding: EdgeInsets.symmetric(horizontal: 10),
    //   height: 60,
    //   decoration: BoxDecoration(
    //     color: activePillColor,
    //     borderRadius: BorderRadius.circular(50), // Bentuk pil
    //   ),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     // mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Icon(icon, size: 28, color: activeColor),
    //       const SizedBox(height: 3),
    //       Text(
    //         label,
    //         style: TextStyle(
    //           color: activeColor,
    //           fontSize: 13,
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    //
    // return GestureDetector(
    //   onTap: () => onTabSelected(index),
    //   behavior: HitTestBehavior.opaque, // Pastikan area transparan bisa di-tap
    //   child: isSelected ? activeItem : inactiveItem,
    // );
  }
}