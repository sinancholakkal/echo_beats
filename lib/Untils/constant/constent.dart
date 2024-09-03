import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


Widget sizeBox({int h=0,int w=0}){
  return SizedBox(height: h.toDouble(),width: w.toDouble(),);
}
// final audioQuery = OnAudioQuery();
// final AudioPlayer audioPlayer = AudioPlayer();


class AudioPlayerService {
  static final AudioPlayer player = AudioPlayer();

  // This is a getter that returns the _audioPlayer instance
  // static AudioPlayer get player => _audioPlayer;

  // static void play(String uri) {
  //   _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
  //   _audioPlayer.play();
  // }

  // static void stop() {
  //   _audioPlayer.stop();
  // }
  // static void skip(){
  //   _audioPlayer.seekToNext();
  // }

  //  static void seekToPrevious(){
  //   _audioPlayer.seekToPrevious();
  // }
}


