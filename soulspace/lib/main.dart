import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/ui/screens/chatbot.dart';           // ← Your Chatbot page
import 'src/ui/screens/journal_page.dart';       // ← ADDED: Journal page import
import 'src/utils/app_colors.dart';
import 'src/ui/screens/main_page.dart';

void main() {
  runApp(const SoulSpaceApp());
}

class SoulSpaceApp extends StatelessWidget {
  const SoulSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
              bodyMedium: TextStyle(color: Color(0xFF333333)),
            ),
            useMaterial3: true,
            fontFamily: 'Poppins',
          ),

          // ────── ROUTES ──────
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context,) => const OnboardingScreen(),
            '/auth': (context) => const AuthScreen(),
            '/home': (context) => const MainPage(username: "Jane"),
          },
        );
      },
    );
  }
}

// Quick home screen to test both pages instantly
class QuickTestHome extends StatelessWidget {
  const QuickTestHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "SoulSpace\nTesting",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 80),

              // Go to Chatbot
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Chatbot())),
                icon: const Icon(Icons.smart_toy, size: 32),
                label: const Text("Chat with Joy", style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPink,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),

              const SizedBox(height: 40),

              // Go to Journal
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalPage())),
                icon: const Icon(Icons.book, size: 32),
                label: const Text("Journal", style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sage,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}