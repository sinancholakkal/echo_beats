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


