// src/ui/screens/home_screen.dart
import 'dart:ui'; // <-- REQUIRED FOR ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows content behind nav bar
      body: Stack(
        children: [
          // ────── 1. BASE GRADIENT (Like your proposal image) ──────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8F5FF), // Light blue top
                  Color(0xFFFCE4EC), // Soft pink middle
                  Color(0xFFE1F5FE), // Light cyan bottom
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // ────── 2. THREE BLURRED CIRCLES (Pinterest video style) ──────
          // Circle 1: Top-left, large, soft pink
          Positioned(
            top: -180.h,
            left: -180.w,
            child: _buildBlurCircle(
              size: 500.w,
              color: const Color(0xFFFFBBB2).withValues(alpha: 0.25), // withOpacity → withValues
              blur: 80,
            ),
          ),

          // Circle 2: Bottom-right, larger, warm pink
          Positioned(
            bottom: -220.h,
            right: -220.w,
            child: _buildBlurCircle(
              size: 600.w,
              color: const Color(0xFFFF9B92).withValues(alpha: 0.30),
              blur: 100,
            ),
          ),

          // Circle 3: Center-left, medium, sage green
          Positioned(
            top: 150.h,
            left: -100.w,
            child: _buildBlurCircle(
              size: 400.w,
              color: const Color(0xFF818C69).withValues(alpha: 0.20),
              blur: 70,
            ),
          ),

          // ────── 3. MAIN CONTENT (Will be layered next) ──────
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    "Hi, $username!",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    "How are you feeling today?",
                    style: TextStyle(fontSize: 16.sp, color: AppColors.lightBlack),
                  ),
                  const Spacer(),
                  Center(
                    child: Text(
                      "Background Ready!",
                      style: TextStyle(fontSize: 24.sp, color: AppColors.black.withValues(alpha: 0.8)),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),

      // ────── BOTTOM NAVIGATION BAR (5 tabs, Home in center) ──────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 2,
          selectedItemColor: AppColors.forest,
          unselectedItemColor: AppColors.lightBlack,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (index) {
            // Later: Navigate to screens
            print("Nav to index: $index");
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Journal'),
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Meditate'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Mood'),
          ],
        ),
      ),
    );
  }

  // ────── HELPER: Blurred Circle (Reusable) ──────
  Widget _buildBlurCircle({
    required double size,
    required Color color,
    required double blur,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            color: color,
          ),
        ),
      ),
    );
  }
}