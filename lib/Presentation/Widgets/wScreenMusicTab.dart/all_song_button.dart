import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class AllSongPlayButton extends StatelessWidget {
  const AllSongPlayButton({
    super.key,
    required this.allSong,
  });

  final List allSong;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.to(
          () => ScreenPlaying(
            idx: 0,
            songModelList: allSong,
          ),
          transition: Transition.cupertino,
          duration: const Duration(seconds: 1),
        );
      },
      icon: const Icon(
        Icons.play_circle,
        color: white,
        size: 40,
      ),
    );
  }
}
