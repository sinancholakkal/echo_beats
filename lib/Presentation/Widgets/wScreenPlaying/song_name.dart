import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

class SongName extends StatelessWidget {
  const SongName({
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
      builder: (BuildContext context, val, Widget? child) {
        print(
            """${widget.songModelList[val].displayNameWOExt} =================================================""");
        return MarqueeText(
          speed: 30,
          text: TextSpan(
            text:
                widget.songModelList[val].displayNameWOExt,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: white,
            ),
          ),
        );
      },
    );
  }
}
