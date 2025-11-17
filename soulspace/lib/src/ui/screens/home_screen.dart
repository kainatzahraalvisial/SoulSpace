import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMood = "";

  final List<String> weekdays = ["S", "M", "T", "W", "T", "F", "S"];
  final int currentWeekday = DateTime.now().weekday; // 1=Mon ... 7=Sun

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

    // Show a short SnackBar as confirmation
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
          // BACKGROUND IMAGE (90% OPACITY)
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // CONTENT
          SafeArea(
            child: Column(
              children: [
                // FIXED HEADER (NOT SCROLLABLE)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: avatar + calendar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // navigate to profile (hook up in your router)
                              Navigator.of(context).pushNamed('/profile');
                            },
                            child: const CircleAvatar(
                              radius: 26,
                              backgroundImage:
                                  AssetImage('assets/images/avatar.png'),
                            ),
                          ),
                          Icon(Icons.calendar_today_outlined,
                              color: AppColors.black, size: 22),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Greeting
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

                // SCROLLABLE BODY (header fixed)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // Weekday row (S M T W T F S) with today's highlight
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
                                    fontWeight:
                                        isToday ? FontWeight.w600 : FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),


                          // Emoji mood row
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
                                                color: AppColors.forest.withValues(alpha: 0.4),
                                                blurRadius: 12,
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

                          // Quote card (forest green)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.forest,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Peace comes from within, Do not seek it without",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Feature cards
                          _buildFeatureCard(
                            title: "How was your day?",
                            buttonText: "Write Journal",
                            image: 'assets/images/journal.png',
                            onTap: () => Navigator.of(context).pushNamed('/journal'),
                          ),
                          _buildFeatureCard(
                            title: "Unlock your inner peace",
                            buttonText: "Meditate",
                            image: 'assets/images/meditation.png',
                            onTap: () => Navigator.of(context).pushNamed('/meditate'),
                          ),
                          _buildFeatureCard(
                            title: "Talk to your buddy",
                            buttonText: "Talk",
                            image: 'assets/images/chatbot.png',
                            onTap: () => Navigator.of(context).pushNamed('/chatbot'),
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

      // reusable nav bar from widgets folder
      
    );
  }

  // FEATURE CARD BUILDER
  Widget _buildFeatureCard({
    required String title,
    required String buttonText,
    required String image,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: 170,
      decoration: BoxDecoration(
        color: AppColors.sage.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text + Button
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.softCoral,
                          AppColors.peach,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.softCoral.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Text(
                      buttonText,
                      style: GoogleFonts.poppins(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Image
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Image.asset(image, height: 120),
          ),
        ],
      ),
    );
  }
}
