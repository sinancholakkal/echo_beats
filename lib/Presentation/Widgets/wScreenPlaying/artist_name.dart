import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

class ArtistName extends StatelessWidget {
  const ArtistName({
    super.key,
    required this.currentIndex,
    required this.widget,
  });

  final ValueNotifier<int> currentIndex;
  final ScreenPlaying widget;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndex,
      builder:
          (BuildContext context, value, Widget? child) {
        return MarqueeText(
          speed: 30,
          text: TextSpan(
            text: widget.songModelList[value].artist,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: white,
            ),
          ),
        );
      },
    );
  }
}
