import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double width = size.width;
    double height = size.height;
    double archHeight = 90.0;

    path.moveTo(0, 0);
    path.lineTo(0, height - archHeight);
    path.quadraticBezierTo(width / 2, height, width, height - archHeight);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class JournalHistoryPage extends StatelessWidget {
  const JournalHistoryPage({super.key});

  final List<Map<String, dynamic>> mockEntries = const [
    {
      "title": "Today was best day",
      "preview": "I felt it building up all day, a lump in my throat finally turned into happy tears...",
      "date": "24/08/25",
      "color": Color(0xFFFFE4E1),
    },
    {
      "title": "Worst day of my life",
      "preview": "Today, I am feeling sad because of my exam results...",
      "date": "16/08/24",
      "color": Color(0xFFFFF3E0),
    },
    {
      "title": "Today was best day",
      "preview": "I made a cake for my friends and seeing their smiles made my heart so full...",
      "date": "22/06/24",
      "color": Color(0xFFE8F5E9),
    },
    {
      "title": "Stressed",
      "preview": "Feeling really overwhelmed with work and exams...",
      "date": "10/05/24",
      "color": Color(0xFFFCE4EC),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),

      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 360,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFF0F0),
                        Color(0xFFFFD4D4),
                        Color(0xFFFFF5F5),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Color(0xFFFFCFCF), shape: BoxShape.circle),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "History",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Image.asset(
                  "assets/images/history.png",
                  width: 220,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: mockEntries.length,
                    itemBuilder: (context, index) {
                      final entry = mockEntries[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: entry["color"],
                            borderRadius: BorderRadius.circular(40),
                            
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry["title"],
                                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      entry["preview"],
                                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "created on ${entry["date"]}",
                                      style: TextStyle(fontSize: 13.5, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 22),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}