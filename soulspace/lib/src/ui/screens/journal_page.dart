import 'package:flutter/material.dart';
import 'journal_history_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import 'dart:ui';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});
  @override State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _journalController = TextEditingController();

  void _showAIAnalysis() {
    if (_journalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please write something first")));
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Container(width: 60, height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3))),
            const SizedBox(height: 24),
            Text("Your AI Insight", style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            Text("Your writing reflects a peaceful and reflective mood today.\n\nKey Emotions: Calm • Gratitude • Hope\nStress Level: Low\n\nYou're doing amazing.", 
                 style: GoogleFonts.poppins(fontSize: 17, height: 1.8), textAlign: TextAlign.center),
            const Spacer(),
            ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFE5E5), padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), 
                 child: Text("Close", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFFCB8A8A)))),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

    return Scaffold(
      backgroundColor: AppColors.white.withValues(alpha: 0.98),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text("Journal", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.black)),
                const SizedBox(height: 8),
                Text("Take a moment to reflect on your day", style: GoogleFonts.poppins(fontSize: 17, color: AppColors.lightBlack.withValues(alpha: 0.7), fontWeight: FontWeight.w500)),
                const SizedBox(height: 32),

                TextField(controller: _titleController, style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700), 
                  decoration: InputDecoration(hintText: "Title", hintStyle: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.grey.shade400), border: InputBorder.none)),
                const SizedBox(height: 8),
                Text(today, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black54)),
                const SizedBox(height: 20),

                Container(
                  height: 420,
                  padding: const EdgeInsets.fromLTRB(28, 36, 28, 60),
                  decoration: BoxDecoration(color: const Color(0xFFFFFDF6), borderRadius: BorderRadius.circular(28), border: Border.all(color: const Color(0xFFE8D9C5).withValues(alpha: 0.7), width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 8))]),
                  child: Stack(children: [
                    Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: NotebookLinesPainter()))),
                    TextField(controller: _journalController, maxLines: null, cursorWidth: 1.8, cursorColor: AppColors.sage, cursorHeight: 24,
                      style: GoogleFonts.poppins(fontSize: 17, height: 2.6, color: AppColors.black.withValues(alpha: 0.88), fontWeight: FontWeight.w500),
                      decoration: InputDecoration(hintText: "Start writing here...", hintStyle: GoogleFonts.poppins(fontSize: 17, color: Colors.grey.shade400), border: InputBorder.none, contentPadding: EdgeInsets.zero)),
                  ]),
                ),

                const SizedBox(height: 40),

                
                Row(children: [
                  Expanded(child: _filledGradientButton(text: "Save Entry")),
                  const SizedBox(width: 16),
                  Expanded(child: _gradientBorderOnlyButton(text: "Analyze with AI", onTap: _showAIAnalysis)),
                ]),

                const SizedBox(height: 24),

                _filledGradientButton(text: "View Your Past Entries", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalHistoryPage()))),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filledGradientButton({required String text, VoidCallback? onTap}) {
    const colors = [Color(0xFF561d46), Color(0xFFae6a97), Color(0xFFec8bbb), Color(0xFFf8f0ea)];
    return GestureDetector(
      onTap: onTap ?? () {
        if (_titleController.text.trim().isNotEmpty || _journalController.text.trim().isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Saved!"), backgroundColor: AppColors.sage.withValues(alpha: 0.9)));
          _titleController.clear(); _journalController.clear();
        }
      },
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [BoxShadow(color: colors.first.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Center(child: Text(text, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white))),
      ),
    );
  }

  Widget _gradientBorderOnlyButton({required String text, required VoidCallback onTap}) {
    const colors = [Color(0xFF561d46), Color(0xFFae6a97), Color(0xFFec8bbb), Color(0xFFf8f0ea)];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.all(4), 
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Container(
          decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.98), borderRadius: BorderRadius.circular(28)),
          child: Center(
            child: Text(text, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700, color: const Color(0xFF561d46))),
          ),
        ),
      ),
    );
  }
}

class NotebookLinesPainter extends CustomPainter {
  @override void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFE8D9C5).withValues(alpha: 0.6)..strokeWidth = 1.3;
    double y = 46;
    while (y < size.height + 100) { canvas.drawLine(Offset(0, y), Offset(size.width, y), paint); y += 46; }
  }
  @override bool shouldRepaint(_) => false;
}