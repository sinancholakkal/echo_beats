import 'dart:developer';
import 'package:echo_beats_music/Presentation/Pages/Settigs/settings.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_add_playlist.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/add_song_to_recently.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/artist_name.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/favorite_button.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/favsong_add_or_delete.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/play_pause_button.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/previous_button.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/repeat_button.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/skip_button.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/slider_duration.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/song_image.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/song_name.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenPlaying/song_share_button.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:echo_beats_music/database/functions_hive/all_songs/db_function.dart';
import 'package:echo_beats_music/database/functions_hive/favourite/db_function.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
class ScreenPlaying extends StatefulWidget {
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
  List<AudioSource> songList = [];
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  final _audioQuery = OnAudioQuery();
  int min = 1;
  Future<void> playSong() async {
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
              //artUri: Uri.parse(element.id.toString()),
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
          addSongRecently(widget.songModelList,currentIndex.value);
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

  Future<void>initialize()async{
    await playSong();
    AudioPlayerService.player.play();
    isPlaying.value = true;
    durationSet();
    chekk();
  }

  @override
  void initState() {
    super.initState();
    initialize();
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
                      //Share button------------
                      SongShareButton(widget: widget, currentIndex: currentIndex),
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
                  //Song image container-------------------
                  SongImage(currentIndex: currentIndex, widget: widget),
                  sizeBox(h: 40),
                  SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        //Song name-------------------
                        SongName(currentIndex: currentIndex, widget: widget),
                        //Artist Name----------------------------
                        ArtistName(currentIndex: currentIndex, widget: widget),
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
                      SliderDuration(position: _position, duration: _duration),
                    ],
                  ),
                  sizeBox(h: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Repeat button-----------------------
                      RepeatButton(isRepeat1: isRepeat1),
                      //Previous Button----------------
                      const  PreviousButton(),

                      //Play pause-------------------------------------
                      PlayPauseButton(playPause: _playPause),
                      //Skip button-------------------------------------------------------------
                      const SkipButton(),
                      //Favourate------------------------------------------
                      FavoriteButton(isFavorate: _isFavorate, audioQuery: _audioQuery, currentIndex: currentIndex, widget: widget),
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
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for (var id in removeFromfav) {
      deleteFromFavorite(id);
    }
  }
}