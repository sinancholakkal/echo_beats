
import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';
part 'favourite_class_model.g.dart';

@HiveType(typeId: 0)
class SongModelClass {
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

  @HiveField(5)
  final String songPath;



  SongModelClass({
    required this.id,
    required this.displayNameWOExt,
    required this.artist,
    required this.uri,
    required this.imageUri,
    required this.songPath
  });
   Uint8List get imageBytes => imageUri;

  get album => null;

  set imageBytes(Uint8List bytes) {
    imageUri = bytes;
  }
}


