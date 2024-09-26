import 'dart:io';


import 'package:echo_beats_music/Presentation/Pages/HomePages/Tabs/screen_music_tab.dart';
import 'package:echo_beats_music/database/functions_hive/all_songs/db_function.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


Widget sizeBox({int h=0,int w=0}){
  return SizedBox(height: h.toDouble(),width: w.toDouble(),);
}



class AudioPlayerService {
  static final AudioPlayer player = AudioPlayer();

}




