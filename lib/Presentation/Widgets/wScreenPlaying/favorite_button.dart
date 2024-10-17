import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/favsong_add_or_delete.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required ValueNotifier<bool> isFavorate,
    required OnAudioQuery audioQuery,
    required this.currentIndex,
    required this.widget,
  }) : _isFavorate = isFavorate, _audioQuery = audioQuery;

  final ValueNotifier<bool> _isFavorate;
  final OnAudioQuery _audioQuery;
  final ValueNotifier<int> currentIndex;
  final ScreenPlaying widget;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isFavorate,
      builder: (BuildContext context, value, Widget? child) {
        return IconButton(
          onPressed: () async {
            favSongAddOrDelete(value,_audioQuery,currentIndex.value,widget.songModelList);
            _isFavorate.value = !value;
          },
          icon: Icon(
            value == false
                ? Icons.favorite_border
                : Icons.favorite,
            color: white,
            size: 30,
          ),
        );
      },
    );
  }
}