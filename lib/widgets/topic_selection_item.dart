import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF7A6BFF);
const Color kSecondaryColor = Color(0xFF3D425B);

class TopicSelectionItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onToggle;

  const TopicSelectionItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle, // Panggil callback saat di-tap
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 23),
        decoration: ShapeDecoration(
          color: kSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            // Border Ungu jika terpilih (visual feedback)
            side: isSelected
                ? const BorderSide(color: kPrimaryColor, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Nama Topik
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'TT Norms Pro',
                fontWeight: FontWeight.w500,
              ),
            ),

            // Checkbox Kustom
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isSelected ? kPrimaryColor : Colors.white70,
                  width: 2,
                ),
                color: isSelected ? kPrimaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}