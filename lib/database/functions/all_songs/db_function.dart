import 'package:echo_beats_music/database/models/allsongs/all_song_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<AllSongModel>> allSongNotifier = ValueNotifier([]);

Future<void> addToAllsong(AllSongModel song)async{
  
  final openDB = await Hive.openBox<AllSongModel>("all_song");
// await openDB.add(song);
  await openDB.put(song.id, song);
  print(song.displayNameWOExt);

  allSongNotifier.value.add(song);
  allSongNotifier.notifyListeners();
}

Future<void> getAllSongs()async{
  final songDB = await Hive.openBox<AllSongModel>('all_song');
  allSongNotifier.value.clear();
  allSongNotifier.value.addAll(songDB.values);
  allSongNotifier.notifyListeners();
}