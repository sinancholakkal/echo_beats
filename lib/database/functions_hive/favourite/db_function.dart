
import 'package:echo_beats_music/database/models/favourite/favourite_class_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<SongModelClass>> favouriteClassModelList = ValueNotifier([]);

Future<void> addSongToFavourite(SongModelClass song)async{
  print(song);
  final openDB = await Hive.openBox<SongModelClass>("song_box");
// await openDB.add(song);
  await openDB.put(song.id, song);

  favouriteClassModelList.value.add(song);
  favouriteClassModelList.notifyListeners();
}

Future<void> getAllSongFromFavourite()async{
  final songDB = await Hive.openBox<SongModelClass>('song_box');
  favouriteClassModelList.value.clear();
  favouriteClassModelList.value.addAll(songDB.values);
  favouriteClassModelList.notifyListeners();
}

Future<void> deleteFromFavorite(int id)async{
  final openDB = await Hive.openBox<SongModelClass>('song_box');
  await openDB.delete(id);
  await getAllSongFromFavourite();
}