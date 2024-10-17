import 'dart:typed_data';

import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/database/functions_hive/favourite/db_function.dart';
import 'package:echo_beats_music/database/models/allsongs/all_song_model.dart';
import 'package:echo_beats_music/database/models/favourite/favourite_class_model.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:echo_beats_music/database/models/recentlyPlayed/recently_played_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<int> removeFromfav = [];

Future<void> favSongAddOrDelete(dynamic isFavorate, dynamic audioQuery, int index, List songModelList) async {
    if (isFavorate.value == false) {
      Uint8List? imagebyte;
      if (await audioQuery.queryArtwork(
              songModelList[index].id, ArtworkType.AUDIO) !=
          null) {
        imagebyte = await audioQuery.queryArtwork(
            songModelList[index].id, ArtworkType.AUDIO);
      }
      final result = SongModelClass(
          id: songModelList[index].id,
          displayNameWOExt:
              songModelList[index].displayNameWOExt,
          artist: songModelList[index].artist!,
          uri: songModelList[index].uri,
          imageUri: imagebyte ?? Uint8List(0),
          songPath:
              songModelList[index] is RecentlyPlayedModel ||
                      songModelList[index]
                          is PlayListSongModel ||
                     songModelList[index] is AllSongModel
                  ? songModelList[index].songPath
                  : songModelList[index].data);
      //Adding song in favoraited
      addSongToFavourite(result);
      showAddedToast(msg: "Favorited");
    } else {
      //Delete song in favoraite
      showAddedToast(msg: "Unfavorited");
      removeFromfav.add(songModelList[index].id);
    }
  }