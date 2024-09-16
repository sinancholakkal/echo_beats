import 'dart:io';


import 'package:echo_beats_music/database/functions_hive/all_songs/db_function.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


Widget sizeBox({int h=0,int w=0}){
  return SizedBox(height: h.toDouble(),width: w.toDouble(),);
}
// final audioQuery = OnAudioQuery();
// final AudioPlayer audioPlayer = AudioPlayer();


class AudioPlayerService {
  static final AudioPlayer player = AudioPlayer();

}

  void deleteSong(String filePath) {
  final file = File(filePath);
  print(file);
  
  try {
    if (file.existsSync()) {
      file.deleteSync();
      print('File deleted successfully');
    } else {
      print('File not exist');
    }
  } catch (e) {
    print('Error deleting file: $e');
  }finally{
    deleteFromAllSong(filePath);
  }
}


