// lib/src/ui/screens/insights_page.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soulspace/src/ui/screens/calm_page.dart';
import 'package:soulspace/src/ui/screens/focus_page.dart';
import '../../utils/app_colors.dart';

import 'breathing_page.dart';           // ← contains BreathingPage

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPink.withValues(alpha: 0.4),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Insights", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.warmPink.withValues(alpha: 0.15),
              child: Icon(Icons.insights_rounded, color: AppColors.warmPink, size: 30),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text("Your wellbeing trends", style: GoogleFonts.poppins(fontSize: 17, color: AppColors.lightBlack, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // TODAY'S MOOD — untouched
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.softCoral, AppColors.peach, AppColors.purple],
                      ),
                      borderRadius: BorderRadius.circular(38),
                    ),
                    child: Row(
                      children: [
                        const Text("Calm", style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Today's Mood", style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
                              const SizedBox(height: 6),
                              Text("Calm", style: GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.black)),
                              Text("11:45 AM", style: GoogleFonts.poppins(fontSize: 15, color: AppColors.gray)),
                              const SizedBox(height: 14),
                              Text("You're in a peaceful state today. Great job staying grounded.", style: GoogleFonts.poppins(fontSize: 16.5, color: Colors.black87)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // WEEKLY GRAPH — untouched
                  Text("This Week", style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w700, color: AppColors.black)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(color: AppColors.shockingPink.withValues(alpha: 0.4), width: 3),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left_rounded, size: 34, color: AppColors.sage)),
                            Text("12 – 18 Mar", style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600)),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right_rounded, size: 34, color: AppColors.sage)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 230,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 36,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(days[value.toInt()], style: GoogleFonts.poppins(fontSize: 13, color: AppColors.gray)),
                                    );
                                  },
                                )),
                                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              minX: 0, maxX: 6, minY: 0, maxY: 6,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: const [
                                    FlSpot(0, 2.8), FlSpot(1, 4.8), FlSpot(2, 4.2),
                                    FlSpot(3, 1.8), FlSpot(4, 1.2), FlSpot(5, 4.9), FlSpot(6, 3.8),
                                  ],
                                  isCurved: true,
                                  barWidth: 6,
                                  dotData: const FlDotData(show: false),
                                  gradient: const LinearGradient(colors: [AppColors.warmPink, AppColors.peach, AppColors.darkpurple]),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0x33F29B9B), Color(0x22FDD214)],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  Text("Emotion Breakdown", style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w700, color: AppColors.black)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(36), border: Border.all(color: AppColors.deepPurple.withValues(alpha: 0.4), width: 3)),
                    child: Row(
                      children: [
                        SizedBox(width: 190, height: 190, child: PieChart(PieChartData(centerSpaceRadius: 52, sectionsSpace: 4, sections: [
                          PieChartSectionData(value: 34, color: AppColors.purple, title: "34%", titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          PieChartSectionData(value: 28, color: AppColors.peach, title: "28%", titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          PieChartSectionData(value: 22, color: AppColors.lightyellow, title: "22%", titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                          PieChartSectionData(value: 16, color: AppColors.lightblue, title: "16%", titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ]))),
                        const SizedBox(width: 24),
                        Column(children: [
                          _legend("Anxiety", AppColors.purple),
                          _legend("Sadness", AppColors.peach),
                          _legend("Joy", AppColors.lightyellow),
                          _legend("Love", AppColors.lightblue),
                        ]),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  Text("AI Summary", style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w700, color: AppColors.black)),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(36), border: Border.all(color: AppColors.yellow.withValues(alpha: 0.4), width: 3)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [const Icon(Icons.psychology_alt_rounded, color: AppColors.warmPink, size: 30), const SizedBox(width: 10), const Expanded(child: Text("This week you've been mostly calm and joyful.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))]),
                        const SizedBox(height: 20),
                        _summary("Dominant emotion", "Joy"),
                        _summary("Mood trend", "Stable with upward spikes"),
                        _summary("Most written about", "Gratitude & relationships"),
                        _summary("Recommendation", "Keep this energy going"),
                      ],
                    ),
                  ),

                  // RECOMMENDATIONS — GORGEOUS + REAL ROUTES
                  const SizedBox(height: 32),
                  Text("Recommended for You", style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w700, color: AppColors.black)),
                  const SizedBox(height: 16),

                  _gradientCard(context, "Take 5 deep breaths", Icons.air, const [AppColors.blush, AppColors.lightpurple], const BreathingPage()),
                  //_gradientCard(context, "Write 3 things you're grateful for", Icons.favorite_border, const [AppColors.peach, AppColors.lightyellow], const GratitudePage()),
                  _gradientCard(context, "Get a good sleep", Icons.music_note_rounded, const [AppColors.lightblue, AppColors.lightpurple], const FocusPage()),
                  _gradientCard(context, "Do meditiation", Icons.self_improvement_rounded, const [AppColors.purple, AppColors.lightyellow], const CalmPage()),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(String label, Color color) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(children: [Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 12), Text(label, style: GoogleFonts.poppins(fontSize: 16, color: AppColors.black))]),
      );

  Widget _summary(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: RichText(text: TextSpan(style: GoogleFonts.poppins(fontSize: 16, color: AppColors.black), children: [TextSpan(text: "• $label: "), TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w600))])),
      );

  Widget _gradientCard(BuildContext context, String text, IconData icon, List<Color> baseColors, Widget destination) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: baseColors.map((c) => c.withValues(alpha:0.22)).toList()),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [BoxShadow(color: baseColors.first.withValues(alpha:0.18), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundColor: Colors.white.withValues(alpha: 0.4), child: Icon(icon, color: Colors.black87, size: 30)),
            const SizedBox(width: 20),
            Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 18, color: AppColors.black, fontWeight: FontWeight.w500))),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black54, size: 20),
          ],
        ),
      ),
    );
  }
}