  import 'dart:developer';

import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/add_song_to_recently.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:echo_beats_music/database/functions_hive/all_songs/db_function.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> playSongDefenition(int currentIndex, int idx, List<AudioSource> songList, dynamic songModelList, void Function() chekk) async {
    try {
      currentIndex = idx;
      songList.clear(); // Clear the previous song list to avoid duplication
      for (var element in songModelList) {
        songList.add(
          AudioSource.uri(
            Uri.parse(element.uri!),
            tag: MediaItem(
              id: element.id.toString(),
              album: element.album ?? "No Album",
              title: element.displayNameWOExt,
              //artUri: Uri.parse(element.id.toString()),
            ),
          ),
        );
      }
    
      //It is for reset player
      await AudioPlayerService.player.setAudioSource(
        ConcatenatingAudioSource(children: songList),
        initialIndex: idx,
      );
    
      // Listen for the current song index change
      AudioPlayerService.player.currentIndexStream.listen((index) {
        if (index != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            musicNameNotifier.value =
                songModelList[index].displayNameWOExt;
            musicNameNotifier.notifyListeners();
            allSongNotifier.notifyListeners();
          });
          currentIndex = index;
          chekk();
          addSongRecently(songModelList,currentIndex);
        }
      });
    } on Exception catch (e) {
      log("Error in parsing: $e");
    }
  }