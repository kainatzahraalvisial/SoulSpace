import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart'; 
import '../../utils/app_colors.dart';

class SleepTrack {
  final String title;
  final String subtitle;
  final String asset;
  SleepTrack(this.title, this.subtitle, this.asset);
}

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});
  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int currentIndex = 0;
  Duration position = Duration.zero;
  Duration? totalDuration;
  Timer? _sleepTimer;
  int _remainingSeconds = 0;

  bool isPlaying = false;
  bool isLoading = false;

  final List<SleepTrack> tracks = [
    SleepTrack("Night Rain", "Gentle rain on roof", "audios/rain.mp3"),
    SleepTrack("Ocean Waves", "Calm waves at night", "audios/lake.mp3"),
    SleepTrack("Thunder", "Calm thunder & beats", "audios/thunder.mp3"),
  ];

  @override
  void initState() {
    super.initState();
    _setupAudioListeners();
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
  }

  Future<void> _playTrack(SleepTrack track) async {
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
      // This line fixes the "first play doesn't work" bug
      await _audioPlayer.play(AssetSource(tracks[currentIndex].asset));
    }
  }
  void _setTimer(int minutes) {
    _sleepTimer?.cancel();
    _remainingSeconds = minutes * 60;

    if (minutes == 0) {
      setState(() {});
      return;
    }

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _audioPlayer.stop();
        _sleepTimer?.cancel();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
    setState(() {});
  }

  String _format(Duration d) => "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";

  @override
  void dispose() {
    _audioPlayer.dispose();
    _sleepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final track = tracks[currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/sleep_bg.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.15))),

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
                      Text("Sleep", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white)),
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
                        onTap: () => _playTrack(t),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.lightpurple.withValues(alpha: 0.3)
                                : Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selected ? AppColors.yellow : Colors.transparent, width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.lightpurple.withValues(alpha: 0.4),
                                ),
                                child: const Icon(Icons.nights_stay_rounded, color: Colors.white, size: 32),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.title, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
                                    Text(t.subtitle, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                                  ],
                                ),
                              ),
                              if (selected)
                                isLoading
                                    ? const SizedBox(
                                        width: 36,
                                        height: 36,
                                        child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation(AppColors.yellow)),
                                      )
                                    : Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, color: AppColors.yellow, size: 36),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(track.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                      Text(track.subtitle, style: const TextStyle(color: Colors.white60)),

                      const SizedBox(height: 12),

                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                          thumbColor: AppColors.yellow,
                          activeTrackColor: AppColors.yellow.withValues(alpha: 0.7),
                          inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                        ),
                        child: Slider(
                          value: position.inSeconds.toDouble().clamp(0, totalDuration?.inSeconds.toDouble() ?? 1),
                          max: totalDuration?.inSeconds.toDouble() ?? 1,
                          onChanged: (v) => _audioPlayer.seek(Duration(seconds: v.toInt())),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_format(position), style: const TextStyle(color: Colors.white70)),
                            Text(totalDuration != null ? _format(totalDuration!) : "0:00", style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.lightpurple),
                          child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 48, color: AppColors.yellow),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [15, 30, 45, 60, 0].map((min) {
                          final active = _remainingSeconds > 0 && _remainingSeconds ~/ 60 == min;
                          return GestureDetector(
                            onTap: () => _setTimer(min),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: active ? AppColors.yellow : AppColors.lightpurple.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                min == 0 ? "Off" : "$min min",
                                style: GoogleFonts.poppins(color: active ? Colors.black : Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      if (_remainingSeconds > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text("Timer: ${_format(Duration(seconds: _remainingSeconds))}", style: const TextStyle(color: Colors.white70)),
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