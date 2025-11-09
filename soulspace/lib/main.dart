import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/ui/screens/splash_screen.dart';
import 'src/ui/screens/onboarding_screen.dart';
import 'src/ui/screens/auth_screen.dart';
import 'src/utils/app_colors.dart';
import 'src/ui/screens/home_screen.dart';

void main() {
  runApp(const SoulSpaceApp());
}

class SoulSpaceApp extends StatelessWidget {
  const SoulSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Figma design size (iPhone 12/13 – 375×812)
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true, 

      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SoulSpace',

          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.background,
            ),
            textTheme: const TextTheme(
              headlineLarge: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: TextStyle(
                color: Color(0xFF333333),
              ),
            ),
            useMaterial3: true,
            fontFamily: 'Poppins',
          ),

          // ────── ROUTES ──────
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/auth': (context) => const AuthScreen(),
            '/home': (context) => const HomeScreen(username: 'Jane'),
          },
        );
      },
    );
  }
}