
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
  final String? uripath;

  @HiveField(4)
  Uint8List imageUri;

  // @HiveField(5)
  // bool isFavorite; 

  SongModelClass({
    required this.id,
    required this.displayNameWOExt,
    required this.artist,
    required this.uripath,
    required this.imageUri,
    //this.isFavorite=false,
  });
   Uint8List get imageBytes => imageUri;

  get album => null;

  set imageBytes(Uint8List bytes) {
    imageUri = bytes;
  }
}


