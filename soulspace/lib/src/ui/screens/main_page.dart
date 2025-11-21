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
      withNavPadding(const Placeholder()), 
      withNavPadding(const MeditationPage()), 
      withNavPadding(HomeScreen(username: widget.username)), 
      withNavPadding(const Placeholder()), 
      withNavPadding(const Placeholder()), 
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
         
Positioned.fill(
  child: _currentIndex == 2
      ? Image.asset(
          'assets/images/bg.jpg',
          fit: BoxFit.cover,
        )
      : Container(
          color: AppColors.lightBackground, 
        ),
),


         
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
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
