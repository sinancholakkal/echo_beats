import 'dart:typed_data';

import 'package:echo_beats_music/database/models/allsongs/all_song_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier<List<AllSongModel>> allSongNotifier = ValueNotifier([]);

Future<void> addToAllsong(List<SongModel> songs) async {
  Uint8List? imagebyte;
  final openDB = await Hive.openBox<AllSongModel>("all_song");
  await openDB.clear();
  allSongNotifier.value.clear();
  for (var song in songs) {
    var allSong = AllSongModel(
      id: song.id,
      displayNameWOExt: song.displayNameWOExt,
      artist: song.artist ?? "unknown",
      uri: song.uri,
      imageUri: imagebyte ??Uint8List(0),
      songPath: song.data,
    );
   await openDB.put(song.id,allSong);
    print(song.id);

  }
      allSongNotifier.value =openDB.values.toList();
    allSongNotifier.notifyListeners();

}

Future<void> getAllSongs() async {
  final songDB = await Hive.openBox<AllSongModel>('all_song');
  allSongNotifier.value.clear();
  allSongNotifier.value.addAll(songDB.values);
  allSongNotifier.notifyListeners();
}

Future<void>deleteFromAllSong(String path)async{
  final openDB = await Hive.openBox<AllSongModel>('all_song');
 final song =openDB.values.firstWhere((item){
  return path ==item.songPath;
  });
  await openDB.delete(song.id);
  getAllSongs();
}
