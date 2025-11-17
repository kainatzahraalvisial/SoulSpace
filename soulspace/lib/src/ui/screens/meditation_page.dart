import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';
import 'breathing_page.dart';
//import '../calm/calm_page.dart';
//import '../sleep/sleep_page.dart';
//import '../focus/focus_page.dart';

class MeditationPage extends StatelessWidget {
  const MeditationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Text(
                "Meditation",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Choose a session to begin",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 20),

              // GRID
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.70,
                  children: [
                    // BREATHING
                    _buildMeditationCard(
                      title: "Breathing",
                      color: const Color(0xFFF4B1B7),
                      imagePath: "assets/images/breathing.png",
                      onStart: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BreathingPage(),
                          ),
                        );
                      },
                    ),

                    // CALM
                    _buildMeditationCard(
                      title: "Calm",
                      color: const Color(0xFFF3D6C8),
                      imagePath: "assets/images/calm.png",
                      onStart: () {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CalmPage(),
                          ),
                        );*/
                      },
                    ),

                    // SLEEP
                    _buildMeditationCard(
                      title: "Sleep",
                      color: const Color(0xFFD5BFFF),
                      imagePath: "assets/images/sleep.png",
                      onStart: () {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SleepPage(),
                          ),
                        );*/
                      },
                    ),

                    // FOCUS
                    _buildMeditationCard(
                      title: "Focus",
                      color: const Color(0xFFD0ECFF),
                      imagePath: "assets/images/focus.png",
                      onStart: () {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FocusPage(),
                          ),
                        );*/
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------ CARD WIDGET ------------------------------ //

  Widget _buildMeditationCard({
    required String title,
    required Color color,
    required String imagePath,
    required VoidCallback onStart,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // CONTENT
          Column(
            children: [
              const SizedBox(height: 10),

              // IMAGE
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // TITLE
              Center(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 45), // space for floating button
            ],
          ),

          // FLOATING BUTTON
          Positioned(
            bottom: 12,
            right: 12,
            child: FloatingActionButton(
              heroTag: "${title}_btn",
              mini: true,
              backgroundColor: Colors.white,
              elevation: 3,
              onPressed: onStart,
              child: const Icon(Icons.play_arrow, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
