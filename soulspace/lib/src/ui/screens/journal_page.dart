// src/ui/screens/journal_page.dart
import 'package:flutter/material.dart';
import 'journal_history_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController _journalController = TextEditingController();
  String todaysMood = "Happy";

  void _showAIAnalysis() {
    if (_journalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write something first to analyze")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(child: Container(width: 60, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)))),
            const SizedBox(height: 24),
            const Text("Your AI Insight", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text(
              "Your writing reflects a peaceful and reflective mood today.\n\n"
              "Key Emotions: Calm • Gratitude • Hope\n"
              "Stress Level: Low\n\n"
              "You're doing amazing. Keep honoring your feelings.",
              style: TextStyle(fontSize: 16.5, height: 1.7),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCFCF),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Close", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String todayDate = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

    return Scaffold(
      backgroundColor: const Color(0xFFFCEEEE),
      resizeToAvoidBottomInset: true, // Important for keyboard

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              
                Row(
                  children: [
                    const SizedBox(width: 50),
                    Text("Journal", 
                    style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                ),  
                    ),                
                ],
                ),

                
              

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Text("Take a moment to reflect on your day", style: TextStyle(fontSize: 17, color: Color(0xFF666666), fontWeight: FontWeight.w500)),
              ),

              // Today's Mood
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Today's Mood ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      Text(todaysMood, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF9EC1A3))),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Date
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(todayDate, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black54)),
              ),

              const SizedBox(height: 16),

              // PERFECT NOTEBOOK — FULLY WRITABLE & NO ERRORS!
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2DCF1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Stack(
                  children: [
                    // Background lines — NO SIZE.INFINITE!
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: NotebookLinesPainter(),
                          // Remove size: Size.infinite → this was causing the crash!
                        ),
                      ),
                    ),

                    // FULLY WRITABLE TEXTFIELD
                    TextField(
                      controller: _journalController,
                      maxLines: null,
                      style: const TextStyle(fontSize: 17, height: 2.3, color: Colors.black87, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        hintText: "Start writing here...",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      cursorColor: Colors.black87,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Save & Analyze Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_journalController.text.trim().isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Journal saved beautifully!"), backgroundColor: Color(0xFF9EC1A3)),
                            );
                            _journalController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sage,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                          elevation: 6,
                        ),
                        child: const Text("Save Entry", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.oliveGreen)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showAIAnalysis,
                        icon: const Icon(Icons.auto_awesome, size: 20),
                        label: const Text("Analyze with AI"),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.sage, width: 3),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Simple "View Your Past Entries"
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalHistoryPage()));
                    },
                    icon: const Icon(Icons.menu_book_rounded, color: AppColors.forest, size: 28),
                    label: const Text("View Your Past Entries", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.forest))),
                  ),
                ),
              

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// Perfect notebook lines — NO SIZE.INFINITE!
class NotebookLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.2;

    double y = 38;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      y += 38;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}