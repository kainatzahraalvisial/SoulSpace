import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
 State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 7), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/onboarding');
      });
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 

      body: Stack(
        children: [
          Positioned(
            left: 40.w,
            top: 60.h,
            child: Container(
              width: 120.r,
              height: 120.r,
              decoration: const BoxDecoration(
                color: Color(0xCCF8E3E2), 
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 50.w,
            top: 100.h,
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: const BoxDecoration(
                color: Color(0xCCFF9D94), 
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/splash_bg.png',
                  width: 300.r,   
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 40.h),

                Text(
                  'SoulSpace',
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 6,
                    color: AppColors.lightBlack,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Your space for peace of mind and positivity.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poiret One',
                    fontSize: 16.sp,
                    color: const Color(0xFF444444),
                  ),
                ),

                SizedBox(height: 80.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(8, (i) {
                    return ScaleTransition(
                      scale: Tween(begin: 0.6, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _pulseCtrl,
                          curve: Interval(i * 0.1, (i + 1) * 0.1,
                              curve: Curves.easeInOut),  
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: 8.r,
                        height: 8.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFF666666), 
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}