// breathing_page.dart → FINAL UPGRADED VERSION (continuous breathing + extra static star)
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage>
    with TickerProviderStateMixin {
  late final AnimationController _rotateController;
  late final AnimationController _breathController; // now runs forever
  late final Animation<double> _scaleAnimation;

  Timer? _sessionTimer;
  int _remainingSeconds = 60;
  bool _running = false;
  bool _paused = false;

  static const int inhaleSec = 4;
  static const int holdAfterInhaleSec = 4;
  static const int exhaleSec = 6;
  static const int holdAfterExhaleSec = 2;
  static const int cycleTotal = inhaleSec + holdAfterInhaleSec + exhaleSec + holdAfterExhaleSec;

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(vsync: this, duration: const Duration(seconds: 7));
    _breathController = AnimationController(vsync: this, duration: const Duration(seconds: cycleTotal));

    // Continuous breathing scale
    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.25).chain(CurveTween(curve: Curves.easeInOut)), weight: inhaleSec.toDouble()),
        TweenSequenceItem(tween: ConstantTween<double>(1.25), weight: holdAfterInhaleSec.toDouble()),
        TweenSequenceItem(tween: Tween<double>(begin: 1.25, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: exhaleSec.toDouble()),
        TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: holdAfterExhaleSec.toDouble()),
      ],
    ).animate(_breathController);

    // Start breathing IMMEDIATELY and FOREVER
    _breathController.repeat();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _breathController.dispose();
    _sessionTimer?.cancel();
    super.dispose();
  }

  void _startSession() {
    if (_running) return;
    setState(() {
      _remainingSeconds = 60;
      _running = true;
      _paused = false;
    });
    _rotateController.repeat(); // rotation starts only when session begins

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) _stopSession();
      });
    });
  }

  void _pauseSession() {
    _rotateController.stop();
    _sessionTimer?.cancel();
    setState(() => _paused = true);
  }

  void _resumeSession() {
    _rotateController.repeat();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) _stopSession();
      });
    });
    setState(() => _paused = false);
  }

  void _stopSession() {
    _rotateController.stop();
    _sessionTimer?.cancel();
    setState(() {
      _running = false;
      _paused = false;
      _remainingSeconds = 60;
    });
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(1, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  String _phaseLabel() {
    final t = _breathController.value * cycleTotal;
    if (t < inhaleSec) return "Inhale";
    if (t < inhaleSec + holdAfterInhaleSec) return "Hold";
    if (t < inhaleSec + holdAfterInhaleSec + exhaleSec) return "Exhale";
    return "Hold";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final flowerSize = math.min(width * 0.72, 420.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.lightpurple.withValues(alpha: 0.65),
              AppColors.yellow.withValues(alpha: 0.25),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back, color: Colors.white, size: 26)),
                    ),
                    const SizedBox(width: 10),
                    Text("Breathing Exercise", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.white)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                      child: Text(_formatDuration(_remainingSeconds), style: GoogleFonts.poppins(color: AppColors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                // Flower + Breathing + Rotation + Extra Static Star
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // NEW: Extra static star (does NOT rotate or breathe)
                        Positioned(
                          top: flowerSize * 0.05,
                          left: flowerSize * 0.38,
                          child: Icon(Icons.star_rounded, size: flowerSize * 0.07, color: AppColors.white.withValues(alpha: 0.8)),
                        ),

                        // Breathing + Rotating Flower
                        AnimatedBuilder(
                          animation: Listenable.merge([_rotateController, _breathController]),
                          builder: (_, __) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: RotationTransition(
                                turns: _rotateController,
                                child: SizedBox(
                                  width: flowerSize,
                                  height: flowerSize,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Two rotating stars
                                      Positioned(left: flowerSize * 0.12, top: flowerSize * 0.08, child: Icon(Icons.star_rounded, size: flowerSize * 0.06, color: AppColors.white.withValues(alpha: 0.7))),
                                      Positioned(right: flowerSize * 0.12, bottom: flowerSize * 0.08, child: Icon(Icons.star_rounded, size: flowerSize * 0.05, color: AppColors.white.withValues(alpha: 0.6))),

                                      // Your beautiful flower
                                      SvgPicture.asset("assets/svg/flower_outline.svg", width: flowerSize, height: flowerSize),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Phase + seconds
                Center(
                  child: AnimatedBuilder(
                    animation: _breathController,
                    builder: (_, __) {
                      final label = _phaseLabel();
                      final t = _breathController.value * cycleTotal;
                      int secLeft = t < inhaleSec
                          ? (inhaleSec - t).ceil()
                          : t < inhaleSec + holdAfterInhaleSec
                              ? (inhaleSec + holdAfterInhaleSec - t).ceil()
                              : t < inhaleSec + holdAfterInhaleSec + exhaleSec
                                  ? (inhaleSec + holdAfterInhaleSec + exhaleSec - t).ceil()
                                  : (cycleTotal - t).ceil();

                      return Column(
                        children: [
                          Text(label, style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.white)),
                          const SizedBox(height: 6),
                          Text("$secLeft", style: GoogleFonts.poppins(fontSize: 18, color: AppColors.white.withValues(alpha: 0.9))),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Controls (unchanged)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_running)
                        ElevatedButton(
                          onPressed: _startSession,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.oliveGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text("Start", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
                        )
                      else if (!_paused) ...[
                        ElevatedButton(
                          onPressed: _pauseSession,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.oliveGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text("Pause", style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: _stopSession,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.white.withValues(alpha: 0.7)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text("Stop", style: GoogleFonts.poppins(color: AppColors.white)),
                        ),
                      ] else ...[
                        ElevatedButton(
                          onPressed: _resumeSession,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.oliveGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text("Resume", style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: _stopSession,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.white.withValues(alpha: 0.7)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text("Stop", style: GoogleFonts.poppins(color: AppColors.white)),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}