import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:echo_beats_music/Presentation/Pages/Settigs/settings.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_add_playlist.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:echo_beats_music/database/functions_hive/all_songs/db_function.dart';
import 'package:echo_beats_music/database/functions_hive/favourite/db_function.dart';
import 'package:echo_beats_music/database/functions_hive/recentlyPlayed/db_function_recently_played.dart';
import 'package:echo_beats_music/database/models/allsongs/all_song_model.dart';
import 'package:echo_beats_music/database/models/favourite/favourite_class_model.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:echo_beats_music/database/models/recentlyPlayed/recently_played_model.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';

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
  ValueNotifier<bool> isRepeat1 = ValueNotifier<bool>(false);

  List<int> removeFromfav = [];

  List<AudioSource> songList = [];
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  final _audioQuery = OnAudioQuery();
  int min = 1;

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

      //It is for reset player
      await AudioPlayerService.player.setAudioSource(
        ConcatenatingAudioSource(children: songList),
        initialIndex: widget.idx,
      );

      // Listen for the current song index change
      AudioPlayerService.player.currentIndexStream.listen((index) {
        if (index != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            musicNameNotifier.value =
                widget.songModelList[index].displayNameWOExt;
            musicNameNotifier.notifyListeners();
            allSongNotifier.notifyListeners();
          });
          currentIndex.value = index;
          chekk();
          addSongRecently();
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

  void durationSet() {
    AudioPlayerService.player.durationStream.listen((d) {
      if (d != null) {
        _duration.value = d;
      }
    });

    AudioPlayerService.player.positionStream.listen((p) {
      _position.value = p;
    });
  }

  Future<void> sleepMode(int minite) async {
    print("Sleep mode started============================================");
    await Future.delayed(Duration(minutes: minite));
    AudioPlayerService.player.stop();
    isPlaying.value = false;
    _playPause.value = false;
    print("Sleep mode stoped============================================");
  }

  @override
  void initState() {
    super.initState();
    playSong();
    AudioPlayerService.player.play();
    isPlaying.value = true;
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
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  sizeBox(h: 10),
                  Row(
                    children: [
                      //Back button----------
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
                      //Share button---------
                      IconButton(
                        onPressed: () {
                          String? songPath;
                          if (widget.songModelList[currentIndex.value]
                              is SongModel) {
                            songPath =
                                widget.songModelList[currentIndex.value].data;
                          } else if (widget.songModelList[currentIndex.value]
                                  is SongModelClass ||
                              widget.songModelList[currentIndex.value]
                                  is RecentlyPlayedModel ||
                              widget.songModelList[currentIndex.value]
                                  is AllSongModel ||
                              widget.songModelList[currentIndex.value]
                                  is PlayListSongModel) {
                            songPath = widget
                                .songModelList[currentIndex.value].songPath;
                          }

                          Share.shareXFiles([XFile(songPath!)]);
                        },
                        icon: const Icon(
                          Icons.share,
                          size: 30,
                          color: white,
                        ),
                      ),
                      sizeBox(w: 12),
                      PopupMenuButton(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: const Text("Settings"),
                              onTap: () {
                                Get.to(() => const ScreenSettings(),
                                    transition: Transition.cupertino);
                              },
                            ),
                            PopupMenuItem(
                              child: const Text("Add to playlist"),
                              onTap: () {
                                List<dynamic> song = [];
                                song.add(widget.songModelList[currentIndex
                                    .value]); //It is song list for adding playlist
                                Get.to(
                                    () => ScreenAddPlaylist(songModel: song));
                              },
                            ),
                            //for set sleep mode---------------------------
                            PopupMenuItem(
                              child: const Text("Sleep Mode"),
                              onTap: (){
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  int? minutes =
                                      await showSleepModeDialog(context);
                                  if (minutes != null) {
                                    await sleepMode(minutes);
                                  }else{
                                    print(minutes);
                                  }
                                });
                              },
                            )
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
                            print(
                                """${widget.songModelList[val].displayNameWOExt} =================================================""");
                            return MarqueeText(
                              speed: 30,
                              text: TextSpan(
                                text:
                                    widget.songModelList[val].displayNameWOExt,
                                style: const TextStyle(
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
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return MarqueeText(
                              speed: 30,
                              text: TextSpan(
                                text: widget.songModelList[value].artist,
                                style: const TextStyle(
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
                                  if (_position == _duration &&
                                      widget.songModelList.length - 1 ==
                                          currentIndex.value) {
                                    _playPause.value = false;
                                    AudioPlayerService.player.pause();
                                  }
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
                      // Repeat button-----------------------
                      ValueListenableBuilder(
                        valueListenable: isRepeat1,
                        builder: (BuildContext context, value, Widget? child) {
                          return IconButton(
                            onPressed: () {
                              isRepeat1.value = !value;
                              if (value == false) {
                                AudioPlayerService.player
                                    .setLoopMode(LoopMode.one);
                              } else {
                                AudioPlayerService.player
                                    .setLoopMode(LoopMode.off);
                              }
                            },
                            icon: Icon(
                              value == false ? Icons.repeat : Icons.repeat_one,
                              color: white,
                              size: 30,
                            ),
                          );
                        },
                      ),
                      //Previous Button----------------
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

                      //Play pause-------------------------------------
                      ValueListenableBuilder(
                        valueListenable: _playPause,
                        builder: (BuildContext context, value, Widget? child) {
                          return IconButton(
                            onPressed: () {
                              _playPause.value = !_playPause.value;
                              if (_playPause.value == false) {
                                AudioPlayerService.player.pause();
                                isPlaying.value = false;
                              } else {
                                AudioPlayerService.player.play();
                                isPlaying.value = true;
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
                          if (AudioPlayerService.player.hasNext) {
                            AudioPlayerService.player.seekToNext();
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
      ),
    );
  }

  void changeToSecond(int second) {
    Duration duration = Duration(seconds: second);
    AudioPlayerService.player.seek(duration);
  }

  Future<void> favSongAddOrDelete() async {
    if (_isFavorate.value == false) {
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
          imageUri: imagebyte ?? Uint8List(0),
          songPath:
              widget.songModelList[currentIndex.value] is RecentlyPlayedModel ||
                      widget.songModelList[currentIndex.value]
                          is PlayListSongModel ||
                      widget.songModelList[currentIndex.value] is AllSongModel
                  ? widget.songModelList[currentIndex.value].songPath
                  : widget.songModelList[currentIndex.value].data);
      //Adding song in favoraited
      addSongToFavourite(result);
      showAddedToast(msg: "Favorited");
    } else {
      //Delete song in favoraite
      showAddedToast(msg: "Unfavorited");
      removeFromfav.add(widget.songModelList[currentIndex.value].id);
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

// it is for add song into recent list
  void addSongRecently() {
    Uint8List? imagebyte;
    final result = RecentlyPlayedModel(
        id: widget.songModelList[currentIndex.value].id,
        displayNameWOExt:
            widget.songModelList[currentIndex.value].displayNameWOExt,
        artist: widget.songModelList[currentIndex.value].artist ?? "unknown",
        uri: widget.songModelList[currentIndex.value].uri,
        imageUri: imagebyte ?? Uint8List(0),
        timestamp: DateTime.now(),
        //songPath: widget.songModelList[currentIndex.value] is SongModel ? widget.songModelList[currentIndex.value].data : widget.songModelList[currentIndex.value].songPath,
        songPath: widget.songModelList[currentIndex.value]
                    is RecentlyPlayedModel ||
                widget.songModelList[currentIndex.value] is PlayListSongModel ||
                widget.songModelList[currentIndex.value] is AllSongModel
            ? widget.songModelList[currentIndex.value].songPath
            : widget.songModelList[currentIndex.value].data);
    addRecentlyPlayed(result);
  }
}
