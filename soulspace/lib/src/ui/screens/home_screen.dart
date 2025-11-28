import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../utils/app_colors.dart';
import 'setting_page.dart';
import 'journal_page.dart';        
import 'meditation_page.dart';    
import 'chatbot.dart';     

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMood = "";

  final List<String> weekdays = ["S", "M", "T", "W", "T", "F", "S"];
  final int currentWeekday = DateTime.now().weekday;

  final List<Map<String, String>> moodEmojis = [
    {'name': 'happy', 'path': 'assets/images/happy.png'},
    {'name': 'sad', 'path': 'assets/images/sad.png'},
    {'name': 'angry', 'path': 'assets/images/angry.png'},
    {'name': 'worried', 'path': 'assets/images/worried.png'},
    {'name': 'upset', 'path': 'assets/images/upset.png'},
    {'name': 'nervous', 'path': 'assets/images/nervous.png'},
  ];

  void _saveMood(String moodName) {
    setState(() => selectedMood = moodName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Mood saved: $moodName"),
        backgroundColor: AppColors.softCoral.withValues(alpha: 0.95),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/bg.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SettingsPage()),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 26,
                              backgroundImage: AssetImage('assets/images/avatar.png'),
                            ),
                          ),
                          Icon(Icons.calendar_today_outlined, color: AppColors.black, size: 22),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "Hi, ${widget.username}!",
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        "How are you feeling today?",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(7, (index) {
                              final bool isToday = (index == (currentWeekday % 7));
                              return Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? AppColors.softCoral.withValues(alpha: 0.95)
                                      : AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  weekdays[index],
                                  style: GoogleFonts.poppins(
                                    fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 65,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: moodEmojis.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 15),
                              itemBuilder: (context, index) {
                                final mood = moodEmojis[index];
                                final isSelected = selectedMood == mood['name'];
                                return GestureDetector(
                                  onTap: () => _saveMood(mood['name']!),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFFFCEBBE).withValues(alpha: 0.6),
                                                blurRadius: 16,
                                                spreadRadius: 4,
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: Image.asset(
                                      mood['path']!,
                                      height: 45,
                                      width: 45,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 25),

                          _buildQuoteCard(
                            quote: "Peace comes from within. Do not seek it without.",
                            author: "Buddha",
                          ),
                          const SizedBox(height: 20),

                          _buildFeatureCard(
                            title: "How was your day?",
                            buttonText: "Write Journal",
                            image: 'assets/images/journal.png',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const JournalPage()), 
                            ),
                          ),
                          _buildFeatureCard(
                            title: "Unlock your inner peace",
                            buttonText: "Meditate",
                            image: 'assets/images/onboarding2.png',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const MeditationPage()), 
                            ),
                          ),
                          _buildFeatureCard(
                            title: "Talk to your buddy",
                            buttonText: "Talk",
                            image: 'assets/images/chatbot.png',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const Chatbot()), 
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard({required String quote, required String author}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                '"$quote"',
                textAlign: TextAlign.center,
                style: GoogleFonts.greatVibes(
                  fontSize: 28,
                  color: AppColors.black.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '- $author',
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.black.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String buttonText,
    required String image,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 170,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: AppColors.lightPink,
              ),
            ),
            Positioned(
              bottom: -30,
              right: -30,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: AppColors.warmPink.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: onTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFA5C85B),
                                  Color(0xFFD3E281),
                                  Color(0xFFF5B1AC),
                                  Color(0xFFFCEBE7),
                                  Color(0xFFFCEBBE),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFD3E281).withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Text(
                              buttonText,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF2E4F2E),
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Image.asset(image, height: 200, width: 120),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}