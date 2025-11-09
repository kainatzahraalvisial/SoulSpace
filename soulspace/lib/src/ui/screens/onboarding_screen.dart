// src/ui/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Journal Your Thoughts",
      "desc": "Write freely and let your thoughts flow. Reflect on your feelings each day.",
      "main": "assets/images/onboarding1.png",
      "pattern": "assets/images/pattern1.png",
      "patternPos": "bottom-left",
    },
    {
      "title": "Relax and Recharge",
      "desc": "Listen to guided meditations and calming music. Find your inner peace.",
      "main": "assets/images/onboarding2.png",
      "pattern": "assets/images/pattern2.png",
      "patternPos": "bottom-full",
    },
    {
      "title": "AI That Understands You",
      "desc": "Your personal AI companion listens, detects your mood, and helps you manage emotions.",
      "main": "assets/images/onboarding3.png",
      "pattern": "assets/images/pattern3.png",
      "patternPos": "top-full",
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            // ────── PAGE VIEW ──────
            PageView.builder(
              controller: _controller,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _pages.length,
              itemBuilder: (_, index) {
                final page = _pages[index];
                final String patternPos = page["patternPos"] as String;

                return Stack(
                  children: [
                    // ────── PATTERN 1: Bottom-left, larger, fully visible ──────
                    if (patternPos == "bottom-left")
                      Positioned(
                        bottom: -20.h,  // Pull up so full image is visible
                        left: -140.w,    // Pull left
                        child: Image.asset(
                          page["pattern"]!,
                          width: 400.w,
                          height: 400.h,
                          fit: BoxFit.contain,
                        ),
                      ),

                    // ────── PATTERN 2: Full-width bottom, larger, fully inside ──────
                    if (patternPos == "bottom-full")
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Image.asset(
                          page["pattern"]!,
                          height: 450.h,  // Increased size
                          fit: BoxFit.cover,
                        ),
                      ),

                    // ────── PATTERN 3: Full-width top, larger, fully visible ──────
                    if (patternPos == "top-full")
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Image.asset(
                          page["pattern"]!,
                          height: 490.h,  // Increased size
                          fit: BoxFit.cover,
                        ),
                      ),

                    // ────── MAIN CONTENT (Centered, on top of pattern) ──────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Top spacer for top pattern
                          if (patternPos == "top-full") SizedBox(height: 140.h),

                          Image.asset(
                            page["main"]!,
                            height: 240.h,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: 30.h),

                          Text(
                            page["title"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                              height: 1.3,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          Text(
                            page["desc"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.lightBlack,
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 40.h),

                          // ────── NEXT / GET STARTED BUTTON ──────
                          ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.forest,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                              minimumSize: Size(double.infinity, 50.h),
                            ),
                            child: Text(
                              _currentPage == 2 ? "Get Started" : "Next",
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                            ),
                          ),

                          // ────── LOGIN LINK (Last page only) ──────
                          if (_currentPage == 2) ...[
                            SizedBox(height: 16.h),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen())),
                              child: Text(
                                "Already have an account? Log in",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],

                          SizedBox(height: 60.h), // Extra space for bottom pattern
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            // ────── PAGE INDICATOR (3 DOTS) ──────
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    width: _currentPage == i ? 12.w : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: _currentPage == i ? AppColors.black : AppColors.gray,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}