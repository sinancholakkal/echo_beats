import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongImage extends StatelessWidget {
  const SongImage({
    super.key,
    required this.currentIndex,
    required this.widget,
  });

  final ValueNotifier<int> currentIndex;
  final ScreenPlaying widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (BuildContext context, value, Widget? child) {
          return QueryArtworkWidget(
            id: widget.songModelList[value].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Icon(
              Icons.music_note,
              size: 90,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}

