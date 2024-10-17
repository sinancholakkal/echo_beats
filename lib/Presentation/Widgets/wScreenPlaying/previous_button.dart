import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        AudioPlayerService.player.seekToPrevious();
      },
      icon: const Icon(
        Icons.skip_previous_rounded,
        color: white,
        size: 50,
      ),
    );
  }
}

