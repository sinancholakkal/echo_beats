import 'dart:developer';
import 'dart:typed_data';

import 'package:echo_beats_music/Presentation/Pages/Settigs/settings.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:echo_beats_music/database/functions/favourite/db_function.dart';
import 'package:echo_beats_music/database/models/favourite/favourite_class_model.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenPlaying extends StatefulWidget {
  //final AudioPlayer audioPlayer;
  final List<dynamic> songModelList;
  int idx;

  ScreenPlaying({
    //required this.audioPlayer,
    required this.idx,
    required this.songModelList,
    super.key,
  });

  @override
  State<ScreenPlaying> createState() => _ScreenPlayingState();
}

class _ScreenPlayingState extends State<ScreenPlaying> {
  final ValueNotifier<bool> _isFavorate = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _playPause = ValueNotifier<bool>(true);
  final ValueNotifier<Duration> _duration =
      ValueNotifier<Duration>(const Duration());
  final ValueNotifier<Duration> _position =
      ValueNotifier<Duration>(const Duration());

      List<int> removeFromfav =[];

  List<AudioSource> songList = [];
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  final _audioQuery = OnAudioQuery();

  void playSong() async {
    try {
      currentIndex.value = widget.idx;
      songList.clear(); // Clear the previous song list to avoid duplication
      for (var element in widget.songModelList) {
        songList.add(
          AudioSource.uri(
            Uri.parse(element.uri!),
            tag: MediaItem(
              id: element.id.toString(),
              album: element.album ?? "No Album",
              title: element.displayNameWOExt,
              artUri: Uri.parse(element.id.toString()),
            ),
          ),
        );
      }

      // പ്ലേയർ റീസെറ്റ് ചെയ്യുക
      await AudioPlayerService.player.setAudioSource(
        ConcatenatingAudioSource(children: songList),
        initialIndex: widget.idx,
      );
      // AudioPlayerService.player.play(); // Start playing the song

      // // Listen for changes in duration and position
      // AudioPlayerService.player.durationStream.listen((d) {
      //   if (d != null) {
      //     _duration.value = d;
      //   }
      // });

      // AudioPlayerService.player.positionStream.listen((p) {
      //   _position.value = p;
      // });

      // Listen for the current song index change
      AudioPlayerService.player.currentIndexStream.listen((index) {
        if (index != null) {
          currentIndex.value = index;
          chekk();
        }
      });
    } on Exception catch (e) {
      log("Error in parsing: $e");
    }
  }

//Chekking available favorite list
  void chekk() {

    final currentSong = widget.songModelList[currentIndex.value].id;
    _isFavorate.value = false;
    for (int i = 0; i < favouriteClassModelList.value.length; i++) {
      if (favouriteClassModelList.value[i].id == currentSong) {
        _isFavorate.value = true;
        break;
      }
    }
  }

  void durationSet(){
    
     AudioPlayerService.player.durationStream.listen((d) {
        if (d != null) {
          _duration.value = d;
        }
      });

        AudioPlayerService.player.positionStream.listen((p) {
        _position.value = p;
      });
  }

  @override
  void initState() {

    super.initState();
      playSong();
    AudioPlayerService.player.play();
   durationSet();



    //playSong();
    chekk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                sizeBox(h: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 40,
                        color: white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.share,
                        size: 30,
                        color: white,
                      ),
                    ),
                    sizeBox(w: 12),
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text("Settings"),
                            onTap: () {
                              Get.to(() => const ScreenSettings(),
                                  transition: Transition.cupertino);
                            },
                          ),
                        ];
                      },
                      iconColor: white,
                      iconSize: 30,
                    ),
                  ],
                ),
                sizeBox(h: 70),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: currentIndex,
                    builder: (BuildContext context, value, Widget? child) {
                      return QueryArtworkWidget(
                        id: widget.songModelList[value].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          size: 90,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                sizeBox(h: 40),
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: currentIndex,
                        builder: (BuildContext context, val, Widget? child) {
                          return MarqueeText(
                            speed: 30,
                            text: TextSpan(
                              text: widget.songModelList[val].displayNameWOExt,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: white,
                              ),
                            ),
                          );
                        },
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: currentIndex,
                        builder: (BuildContext context, value, Widget? child) {
                          return MarqueeText(
                            speed: 30,
                            text: TextSpan(
                              text: widget.songModelList[value].artist,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: white,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    //Slider -----------------------------------------------------------------
                    ValueListenableBuilder(
                      valueListenable: _position,
                      builder: (BuildContext context, pValue, Widget? child) {
                        return ValueListenableBuilder(
                          valueListenable: _duration,
                          builder:
                              (BuildContext context, dValue, Widget? child) {
                            return Slider(
                              value: pValue.inSeconds.toDouble(),
                              min: const Duration(microseconds: 0)
                                  .inSeconds
                                  .toDouble(),
                              max: dValue.inSeconds.toDouble(),
                              onChanged: (val) {
                                changeToSecond(val.toInt());
                                _position.value =
                                    Duration(seconds: val.toInt());
                              },
                              activeColor: white,
                              inactiveColor: Colors.grey,
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _position,
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return Text(
                                value.toString().split('.')[0],
                                style: TextStyle(
                                  color: white.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: _duration,
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return Text(
                                value.toString().split('.')[0],
                                style: TextStyle(
                                  color: white.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                sizeBox(h: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.repeat,
                        color: white,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AudioPlayerService.player.seekToPrevious();
                      },
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        color: white,
                        size: 50,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _playPause,
                      builder: (BuildContext context, value, Widget? child) {
                        return IconButton(
                          onPressed: () {
                            _playPause.value = !_playPause.value;
                            if (_playPause.value == false) {
                              AudioPlayerService.player.pause();
                            } else {
                              AudioPlayerService.player.play();
                            }
                          },
                          icon: Icon(
                            value
                                ? Icons.pause_circle_filled
                                : Icons.play_circle,
                            color: white,
                            size: 80,
                          ),
                        );
                      },
                    ),
                    //Skip button-------------------------------------------------------------
                    IconButton(
                      onPressed: () {
                        print(AudioPlayerService().hashCode);
                        print("song forword------------------------------------");

                        if(AudioPlayerService.player.hasNext){
                           AudioPlayerService.player.seekToNext();
                        }else{
                          print("No next Song");
                        }
                       
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        color: white,
                        size: 50,
                      ),
                    ),
                    //Favourate------------------------------------------
                    ValueListenableBuilder(
                      valueListenable: _isFavorate,
                      builder: (BuildContext context, value, Widget? child) {
                        return IconButton(
                          onPressed: () async {
                            favSongAddOrDelete();
                            _isFavorate.value = !value;
                          },
                          icon: Icon(
                            value == false
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: white,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeToSecond(int second) {
    Duration duration = Duration(seconds: second);
    AudioPlayerService.player.seek(duration);
  }

  Future<void> favSongAddOrDelete() async {
    print(
        "$_isFavorate @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

    if (_isFavorate.value == false) {
      print("Song added in favorite----------------------");
      Uint8List? imagebyte;
      if (await _audioQuery.queryArtwork(
              widget.songModelList[currentIndex.value].id, ArtworkType.AUDIO) !=
          null) {
        imagebyte = await _audioQuery.queryArtwork(
            widget.songModelList[currentIndex.value].id, ArtworkType.AUDIO);
      }
      final result = SongModelClass(
          id: widget.songModelList[currentIndex.value].id,
          displayNameWOExt:
              widget.songModelList[currentIndex.value].displayNameWOExt,
          artist: widget.songModelList[currentIndex.value].artist!,
          uri: widget.songModelList[currentIndex.value].uri,
          imageUri: imagebyte ?? Uint8List(0));
      addSongToFavourite(result);
    } else {
      removeFromfav.add(widget.songModelList[currentIndex.value].id);
      print("Deleted song ------------------------");
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for (var id in removeFromfav) {
      deleteFromFavorite(id);
    }
  }
}
