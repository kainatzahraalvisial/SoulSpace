import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';  
import '../../utils/app_colors.dart';

class CalmTrack {
  final String title;
  final String subtitle;
  final String assetPath;
  CalmTrack(this.title, this.subtitle, this.assetPath);
}

class CalmPage extends StatefulWidget {
  const CalmPage({super.key});
  @override
  State<CalmPage> createState() => _CalmPageState();
}

class _CalmPageState extends State<CalmPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<CalmTrack> tracks = [
    CalmTrack(
      "Body Scan Meditation",
      "2:45 min • Release tension",
      "audios/body_scan.mp3",
    ),
    CalmTrack(
      "Inner Peace Meditation",
      "10:05 min • Cultivate warmth & inner peace",
      "audios/Inner-peace.mp3",
    ),
  ];

  int currentIndex = 0;
  Duration? duration;
  Duration position = Duration.zero;
  bool isPlaying = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
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
      setState(() => duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => position = p);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _next();
    });
  }

  Future<void> _loadTrack(CalmTrack track) async {
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
      await _audioPlayer.setSource(AssetSource(track.assetPath));
      if (isPlaying) await _audioPlayer.resume();
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _playPause() async {
    if (isLoading) return;
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void _previous() async {
    if (position.inSeconds > 3) {
      await _audioPlayer.seek(Duration.zero);
    } else if (currentIndex > 0) {
      currentIndex--;
      await _loadTrack(tracks[currentIndex]);
      if (isPlaying) await _audioPlayer.resume();
    }
  }

  void _next() async {
    if (currentIndex < tracks.length - 1) {
      currentIndex++;
      await _loadTrack(tracks[currentIndex]);
      if (isPlaying) await _audioPlayer.resume();
    }
  }

  String _format(Duration d) => "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final track = tracks[currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/calm_bg.jpg", fit: BoxFit.cover),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.lightpurple.withValues(alpha: 0.35),
                    Colors.transparent,
                    AppColors.yellow.withValues(alpha: 0.25),
                  ],
                ),
              ),
            ),
          ),

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
                      Text(
                        "Calm & Relax",
                        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: tracks.length,
                    itemBuilder: (ctx, i) {
                      final t = tracks[i];
                      final selected = i == currentIndex;
                      return GestureDetector(
                        onTap: () {
                          currentIndex = i;
                          _loadTrack(t);
                          if (isPlaying) _audioPlayer.resume();
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.warmPink.withValues(alpha: 0.3)
                                : Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selected ? AppColors.warmPink : Colors.transparent, width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.warmPink.withValues(alpha: 0.4),
                                ),
                                child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 32),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.title, style: GoogleFonts.poppins(fontSize: 16.5, fontWeight: FontWeight.w600, color: Colors.white)),
                                    Text(t.subtitle, style: const TextStyle(fontSize: 13.5, color: Colors.white70)),
                                  ],
                                ),
                              ),
                              if (selected)
                                isLoading
                                    ? const SizedBox(width: 36, height: 36, child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation(Colors.white)))
                                    : Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, color: Colors.white, size: 36),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    children: [
                      Text(track.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                      Text(track.subtitle, style: const TextStyle(color: Colors.white60, fontSize: 14)),

                      const SizedBox(height: 14),

                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                          thumbColor: AppColors.warmPink,
                          activeTrackColor: AppColors.warmPink,
                          inactiveTrackColor: Colors.white24,
                        ),
                        child: Slider(
                          value: position.inSeconds.toDouble().clamp(0, duration?.inSeconds.toDouble() ?? 1),
                          max: duration?.inSeconds.toDouble() ?? 1,
                          onChanged: (v) => _audioPlayer.seek(Duration(seconds: v.toInt())),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_format(position), style: const TextStyle(color: Colors.white70)),
                            Text(duration != null ? _format(duration!) : "0:00", style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded, size: 48),
                            color: Colors.white70,
                            onPressed: _previous,
                          ),
                          const SizedBox(width: 32),
                          GestureDetector(
                            onTap: _playPause,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.warmPink),
                              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 50, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 32),
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded, size: 48),
                            color: Colors.white70,
                            onPressed: _next,
                          ),
                        ],
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