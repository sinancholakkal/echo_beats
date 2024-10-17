import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (AudioPlayerService.player.hasNext) {
          AudioPlayerService.player.seekToNext();
        }
      },
      icon: const Icon(
        Icons.skip_next,
        color: white,
        size: 50,
      ),
    );
  }
}
