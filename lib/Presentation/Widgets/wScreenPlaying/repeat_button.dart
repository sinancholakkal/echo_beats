import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class RepeatButton extends StatelessWidget {
  const RepeatButton({
    super.key,
    required this.isRepeat1,
  });

  final ValueNotifier<bool> isRepeat1;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isRepeat1,
      builder: (BuildContext context, value, Widget? child) {
        return IconButton(
          onPressed: () {
            isRepeat1.value = !value;
            if (value == false) {
              AudioPlayerService.player
                  .setLoopMode(LoopMode.one);
            } else {
              AudioPlayerService.player
                  .setLoopMode(LoopMode.off);
            }
          },
          icon: Icon(
            value == false ? Icons.repeat : Icons.repeat_one,
            color: white,
            size: 30,
          ),
        );
      },
    );
  }
}
