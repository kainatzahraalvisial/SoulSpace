import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../utils/app_colors.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      height: 60,
      color: AppColors.warmPink,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: AppColors.softCoral,
      items: const [
        Icon(Icons.book_outlined, size: 28, color: Colors.white),
        Icon(Icons.self_improvement, size: 28, color: Colors.white),
        Icon(Icons.home_filled, size: 28, color: Colors.white),
        Icon(Icons.chat_bubble_outline, size: 28, color: Colors.white),
        Icon(Icons.bar_chart_rounded, size: 28, color: Colors.white),
      ],
      onTap: onTap,
    );
  }
}
