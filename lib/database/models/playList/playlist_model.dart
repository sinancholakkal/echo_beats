import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

part 'playlist_model.g.dart';

@HiveType(typeId: 1)
class PlayListSongModel {
  @HiveField(0)
  int id;

  @HiveField(1)
  final String displayNameWOExt;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String? uri;

  @HiveField(4)
  Uint8List imageUri;

  PlayListSongModel({
    required this.id,
    required this.displayNameWOExt,
    required this.artist,
    required this.uri,
    required this.imageUri,
    //this.isFavorite=false,
  });
   Uint8List get imageBytes => imageUri;

  get album => null;

  set imageBytes(Uint8List bytes) {
    imageUri = bytes;
  }
}

@HiveType(typeId: 2)
class Playlist {
  @HiveField(0)
  int? id;
  @HiveField(1)
  final String name;

  @HiveField(2)
   List<PlayListSongModel> songs;

 Playlist({required this.name, List<PlayListSongModel>? songs, this.id})
      : this.songs = songs ?? [];  // I
}