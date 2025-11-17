// lib/src/ui/screens/main_page.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'meditation_page.dart';
import '../widgets/custom_navbar.dart';
import '../../utils/app_colors.dart';


class MainPage extends StatefulWidget {
  final String username;
  const MainPage({super.key, required this.username});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 2;

  Widget withNavPadding(Widget page) {
    // keep bottom space so content doesn't sit under nav
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: page,
    );
  }

  late final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      withNavPadding(const Placeholder()), // Journal (placeholder)
      withNavPadding(const MeditationPage()), // Meditation
      withNavPadding(HomeScreen(username: widget.username)), // Home
      withNavPadding(const Placeholder()), // Chatbot
      withNavPadding(const Placeholder()), // Insights
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // no extendBody (we intentionally removed it)
      //extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── IMPORTANT ──
          // When on Home tab (index == 2) show the Home wallpaper at the bottom
          // so the nav can visually blend with it. For other tabs we don't render the wallpaper.
          // BACKGROUND LAYER
Positioned.fill(
  child: _currentIndex == 2
      ? Image.asset(
          'assets/images/bg.jpg',
          fit: BoxFit.cover,
        )
      : Container(
          color: AppColors.lightBackground, // choose your soft pink / beige
        ),
),


          // pages (only one visible, others preserved)
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          // overlayed bottom nav — always on top of page content
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                // REMOVE left/right padding so nav touches screen edges
                padding: EdgeInsets.zero,
                child: Material(
                  color: Colors.transparent,
                  child: CustomNavBar(
                    currentIndex: _currentIndex,
                    onTap: (i) => setState(() => _currentIndex = i),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
