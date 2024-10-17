// it is for add song into recent list
  import 'dart:typed_data';

import 'package:echo_beats_music/database/functions_hive/recentlyPlayed/db_function_recently_played.dart';
import 'package:echo_beats_music/database/models/allsongs/all_song_model.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:echo_beats_music/database/models/recentlyPlayed/recently_played_model.dart';

// it is for add song into recent list
void addSongRecently(List songModelList, int index) {
    Uint8List? imagebyte;
    final result = RecentlyPlayedModel(
        id: songModelList[index].id,
        displayNameWOExt:
            songModelList[index].displayNameWOExt,
        artist: songModelList[index].artist ?? "unknown",
        uri:songModelList[index].uri,
        imageUri: imagebyte ?? Uint8List(0),
        timestamp: DateTime.now(),
        //songPath: widget.songModelList[currentIndex.value] is SongModel ? widget.songModelList[currentIndex.value].data : widget.songModelList[currentIndex.value].songPath,
        songPath: songModelList[index]
                    is RecentlyPlayedModel ||
                songModelList[index] is PlayListSongModel ||
                songModelList[index] is AllSongModel
            ? songModelList[index].songPath
            : songModelList[index].data);
    addRecentlyPlayed(result);
  }