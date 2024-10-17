import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/database/models/allsongs/all_song_model.dart';
import 'package:echo_beats_music/database/models/favourite/favourite_class_model.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:echo_beats_music/database/models/recentlyPlayed/recently_played_model.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';

class SongShareButton extends StatelessWidget {
  const SongShareButton({
    super.key,
    required this.widget,
    required this.currentIndex,
  });

  final ScreenPlaying widget;
  final ValueNotifier<int> currentIndex;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        String? songPath;
        if (widget.songModelList[currentIndex.value]
            is SongModel) {
          songPath =
              widget.songModelList[currentIndex.value].data;
        } else if (widget.songModelList[currentIndex.value]
                is SongModelClass ||
            widget.songModelList[currentIndex.value]
                is RecentlyPlayedModel ||
            widget.songModelList[currentIndex.value]
                is AllSongModel ||
            widget.songModelList[currentIndex.value]
                is PlayListSongModel) {
          songPath = widget
              .songModelList[currentIndex.value].songPath;
        }
    
        Share.shareXFiles([XFile(songPath!)]);
      },
      icon: const Icon(
        Icons.share,
        size: 30,
        color: white,
      ),
    );
  }
}