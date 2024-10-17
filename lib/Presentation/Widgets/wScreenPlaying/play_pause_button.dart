import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    required ValueNotifier<bool> playPause,
  }) : _playPause = playPause;

  final ValueNotifier<bool> _playPause;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _playPause,
      builder: (BuildContext context, value, Widget? child) {
        return IconButton(
          onPressed: () {
            _playPause.value = !_playPause.value;
            if (_playPause.value == false) {
              AudioPlayerService.player.pause();
              isPlaying.value = false;
            } else {
              AudioPlayerService.player.play();
              isPlaying.value = true;
            }
          },
          icon: Icon(
            value
                ? Icons.pause_circle_filled
                : Icons.play_circle,
            color: white,
            size: 80,
          ),
        );
      },
    );
  }
}