import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';   
import '../../utils/app_colors.dart';

class FocusTrack {
  final String title;
  final String duration;
  final String asset;
  FocusTrack(this.title, this.duration, this.asset);
}

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});
  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();   
  int currentIndex = 0;
  Duration position = Duration.zero;
  Duration? totalDuration;
  Timer? _focusTimer;
  int _remainingSeconds = 25 * 60;
  bool isPlaying = false;
  bool isLoading = false;

  final List<FocusTrack> tracks = [
    FocusTrack("Deep Focus", "Deep concentration", "audios/deep-focus.mp3"),
    FocusTrack("Brown Noise", "Pure focus sound", "audios/brown-noise.mp3"),
    FocusTrack("Study Focus", "Be in Flow", "audios/study.mp3"),
  ];

  @override
  void initState() {
    super.initState();
    _setupAudioListeners();
    _startTimer();
  }

  void _setupAudioListeners() {
  _audioPlayer.onPlayerStateChanged.listen((state) {
    if (!mounted) return;
    setState(() {
      isPlaying = state == PlayerState.playing;
      if (state == PlayerState.completed) {
        isPlaying = false; 
      }
    });
  });

    _audioPlayer.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => totalDuration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => position = p);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      // Auto loop
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.resume();
    });
  }

  Future<void> _playTrack(FocusTrack track) async {
    final index = tracks.indexOf(track);
    if (currentIndex == index && isPlaying) {
      await _audioPlayer.pause();
      return;
    }

    setState(() {
      currentIndex = index;
      isLoading = true;
    });

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setSource(AssetSource(track.asset));
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);  
    } 
    finally {
      setState(() => isLoading = false);
    }
  }

  void _togglePlayPause() async {
    if (isLoading) return;

    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(tracks[currentIndex].asset));
    }
  }

  void _startTimer() {
    _focusTimer?.cancel();
    _focusTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _focusTimer?.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Focus session complete! Take a break")),
        );
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _setDuration(int minutes) {
    _remainingSeconds = minutes * 60;
    _startTimer();
    setState(() {});
  }

  String _format(Duration d) => "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";

  @override
  void dispose() {
    _audioPlayer.dispose();
    _focusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final track = tracks[currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/focus_bg.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.25))),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.lightPink),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.black, size: 26),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text("Focus", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Center(
                  child: Text(
                    _format(Duration(seconds: _remainingSeconds)),
                    style: GoogleFonts.poppins(fontSize: 72, fontWeight: FontWeight.w300, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),

                Wrap(
                  spacing: 16,
                  children: [10, 25, 45, 60].map((min) {
                    final active = _remainingSeconds ~/ 60 == min;
                    return GestureDetector(
                      onTap: () => _setDuration(min),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: active ? AppColors.yellow : AppColors.lightpurple.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text("$min min", style: GoogleFonts.poppins(color: active ? Colors.black : Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 50),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: tracks.length,
                    itemBuilder: (_, i) {
                      final t = tracks[i];
                      final selected = i == currentIndex;
                      return GestureDetector(
                        onTap: () => _playTrack(t),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.lightpurple.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selected ? AppColors.yellow : Colors.transparent, width: 2),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.headphones_rounded, color: Colors.white, size: 32),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.title, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
                                    Text(t.duration, style: const TextStyle(color: Colors.white70)),
                                  ],
                                ),
                              ),
                              if (selected)
                                isLoading
                                    ? const SizedBox(width: 36, height: 36, child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation(AppColors.yellow)))
                                    : Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, color: AppColors.yellow, size: 36),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(track.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                          thumbColor: AppColors.yellow,
                        ),
                        child: Slider(
                          value: position.inSeconds.toDouble(),
                          max: totalDuration?.inSeconds.toDouble() ?? 1,
                          onChanged: (v) => _audioPlayer.seek(Duration(seconds: v.toInt())),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.lightpurple),
                          child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 48, color: AppColors.yellow),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}