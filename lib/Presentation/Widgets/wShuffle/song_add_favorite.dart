  import 'dart:typed_data';

import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/database/functions_hive/favourite/db_function.dart';
import 'package:echo_beats_music/database/models/allsongs/all_song_model.dart';
import 'package:echo_beats_music/database/models/favourite/favourite_class_model.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:echo_beats_music/database/models/recentlyPlayed/recently_played_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

void songAdtoFavorite(var song, OnAudioQuery audioQuery) async {
    Uint8List? imagebyte;
    if (!isAlreadyFav(song)) {
      if (await audioQuery.queryArtwork(song.id, ArtworkType.AUDIO) != null) {
        imagebyte = await audioQuery.queryArtwork(song.id, ArtworkType.AUDIO);
      }
      final result = SongModelClass(
          id: song.id,
          displayNameWOExt: song.displayNameWOExt,
          artist: song.artist ?? "unknown",
          uri: song.uri,
          imageUri: imagebyte ?? Uint8List(0),
          songPath: song is RecentlyPlayedModel ||
                  song is PlayListSongModel ||
                  song is AllSongModel
              ? song.songPath
              : song.data);
      //Adding song in favoraited
      addSongToFavourite(result);
      showAddedToast(msg: "Favorited");
    } else {
      showAddedToast(msg: "This song already exists in the favorite");
    }
  }

    bool isAlreadyFav(var song) {
    return favouriteClassModelList.value.any((item) {
      return item.id == song.id;
    });
  }