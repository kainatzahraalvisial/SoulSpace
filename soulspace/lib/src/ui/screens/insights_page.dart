import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soulspace/src/ui/screens/calm_page.dart';
import 'package:soulspace/src/ui/screens/focus_page.dart';
import '../../utils/app_colors.dart';
import 'breathing_page.dart';
import 'dart:ui';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  bool _isWeekView = true;
  DateTime _currentDate = DateTime.now();

  void _shiftDate(bool isNext) {
    setState(() {
      if (_isWeekView) {
        _currentDate = _currentDate.add(Duration(days: isNext ? 7 : -7));
      } else {
        _currentDate = DateTime(_currentDate.year, _currentDate.month + (isNext ? 1 : -1));
      }
    });
  }

  String _getFormattedDateRange() {
    if (_isWeekView) {
      final startOfWeek = _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      return "${startOfWeek.day} – ${endOfWeek.day} ${_getMonthName(startOfWeek.month)}";
    } else {
      return _getMonthName(_currentDate.month);
    }
  }

  String _getMonthName(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white.withValues(alpha: 0.4),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Insights",
            style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.black)),
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
            child: Text("Your wellbeing trends",
                style: GoogleFonts.poppins(fontSize: 17, color: AppColors.lightBlack, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildCoodMoodCard(),
                  const SizedBox(height: 32),
                  _buildGraphSection(),
                  const SizedBox(height: 32),
                  _buildEmotionBreakdownSection(),
                  const SizedBox(height: 32),
                  _buildAISummarySection(),
                  const SizedBox(height: 32),
                  Text("Recommended for You",
                      style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w700, color: AppColors.black)),
                  const SizedBox(height: 16),
                  _gradientCard(context, "Take 5 deep breaths", Icons.air,
                      const [AppColors.blush, AppColors.lightpurple], const BreathingPage()),
                  _gradientCard(context, "Get a good sleep", Icons.music_note_rounded,
                      const [AppColors.lightblue, AppColors.lightpurple], const FocusPage()),
                  _gradientCard(context, "Do meditiation", Icons.self_improvement_rounded,
                      const [AppColors.blush, AppColors.lightyellow], const CalmPage()),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildCoodMoodCard() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(38),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.28, 0.55, 0.78, 0.92, 1.0],
            colors: [
              Color(0xFF250e2c),  
              Color(0xFF837ab6),  
              Color(0xFF9d85b6),  
              Color(0xFFcc8db3),  
              Color(0xFFf6a5c0),  
              Color(0xFFf7c2ca),  
            ],
          ),
          borderRadius: BorderRadius.circular(38),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.45),
            width: 1.8,
          ),
        ),
        child: Row(
          children: [
            Image.asset('assets/images/happy.png', height: 64),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Mood",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.95),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Happy",
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.0,
                    ),
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
  Widget _buildGraphSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildToggleButton("Week", _isWeekView, () => setState(() => _isWeekView = true)),
                  const SizedBox(width: 20),
                  _buildToggleButton("Month", !_isWeekView, () => setState(() => _isWeekView = false)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(onTap: () => _shiftDate(false), child: const Icon(Icons.chevron_left, size: 34, color: AppColors.shockingPink)),
                  Text(_getFormattedDateRange(), style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600)),
                  GestureDetector(onTap: () => _shiftDate(true), child: const Icon(Icons.chevron_right, size: 34, color: AppColors.shockingPink)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(height: 250, child: _isWeekView ? _buildWeeklyChart() : _buildMonthlyChart()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.oliveGreen : AppColors.oliveGreen.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Container(height: 2, width: text.length * 10.0, color: isSelected ? AppColors.forest : Colors.transparent),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                final index = value.toInt();
                if (index < 0 || index >= days.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(days[index], style: GoogleFonts.poppins(fontSize: 13, color: AppColors.gray)),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: AppColors.gray.withValues(alpha: 0.2), strokeWidth: 1)),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 2.8, color: AppColors.lightPink, width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 4.8, color: AppColors.lightyellow, width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 4.2, color: AppColors.lightPink, width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 1.8, color: AppColors.lightyellow, width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 1.2, color: AppColors.lightPink, width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 4.9, color: AppColors.lightyellow, width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 3.8, color: AppColors.lightPink, width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
        ],
        minY: 0,
        maxY: 6,
      ),
    );
  }

  Widget _buildMonthlyChart() {
    final List<double> weeklyAverages = [4.2, 3.8, 5.1, 4.6];
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 6,
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                const weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
                final index = value.toInt();
                if (index < 0 || index >= 4) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(weeks[index], style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gray)),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: AppColors.gray.withValues(alpha: 0.2), strokeWidth: 1)),
        borderData: FlBorderData(show: false),
        barGroups: weeklyAverages.asMap().entries.map((e) {
          final index = e.key;
          final value = e.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                color: index % 2 == 0 ?  AppColors.lightPink:  AppColors.lightyellow,
                width: 38,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmotionBreakdownSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 52,
                  sectionsSpace: 4,
                  sections: [
                    PieChartSectionData(value: 34, color: const Color(0xFFA5C858), title: "34%", titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    PieChartSectionData(value: 28, color: const Color(0xFFD3E281), title: "28%", titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                    PieChartSectionData(value: 22, color: const Color(0xFFF5B1AC), title: "22%", titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    PieChartSectionData(value: 16, color: const Color(0xFFFCE8E7), title: "16%", titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _legend("Joy", const Color(0xFFA5C858)),
                _legend("Calm", const Color(0xFFD3E281)),
                _legend("Love", const Color(0xFFF5B1AC)),
                _legend("Peace", const Color(0xFFFCE8E7)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAISummarySection() {
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.topCenter,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 60, left: 10, right: 10),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF728FBD), 
              Color(0xFFa8c3d4),  
              Color(0xFFd0d6df),  
              Color(0xFFeec6c7),  
              Color(0xFFd8b8a4),  
              Color(0xFFc8ceb1),  
            ],
            stops: [0.0, 0.25, 0.45, 0.65, 0.85, 1.0], 
          ),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.yellow, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "This week you've been mostly calm and joyful.",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ),
            const SizedBox(height: 20),
            _starSummary("Dominant emotion", "Joy"),
            _starSummary("Mood trend", "Stable with upward spikes"),
            _starSummary("Most written about", "Gratitude & relationships"),
            _starSummary("Recommendation", "Keep this energy going"),
          ],
        ),
      ),

      Positioned(
        top: -15,
        right: 20, 
        child: Image.asset(
          'assets/images/teddy.png',
          height: 110,
        ),
      ),
    ],
  );
}
  Widget _starSummary(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("✨ ", style: TextStyle(fontSize: 18)),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                  children: [
                    TextSpan(text: "$label: "),
                    TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _legend(String label, Color color) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Container(width: 20, height: 20, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Text(label, style: GoogleFonts.poppins(fontSize: 16, color: AppColors.black)),
          ],
        ),
      );

  Widget _gradientCard(BuildContext context, String text, IconData icon, List<Color> baseColors, Widget destination) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: baseColors.map((c) => c.withValues(alpha: 0.22)).toList()),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [BoxShadow(color: baseColors.first.withValues(alpha: 0.18), blurRadius: 20, offset: const Offset(0, 8))],
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