import 'dart:developer';
import 'dart:typed_data';
import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_selecte.dart';
import 'package:echo_beats_music/Presentation/Widgets/wShuffle/song_add_favorite.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:echo_beats_music/database/functions_hive/all_songs/db_function.dart';
import 'package:echo_beats_music/database/functions_hive/favourite/db_function.dart';
import 'package:echo_beats_music/database/models/allsongs/all_song_model.dart';
import 'package:echo_beats_music/database/models/favourite/favourite_class_model.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:echo_beats_music/database/models/recentlyPlayed/recently_played_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenShuffle extends StatefulWidget {
  ScreenShuffle({super.key});

  @override
  State<ScreenShuffle> createState() => _ScreenShuffleState();
}

class _ScreenShuffleState extends State<ScreenShuffle> {
  final _audioQuery = OnAudioQuery();

  ValueNotifier<int?> songCount = ValueNotifier<int?>(null);

  ValueNotifier<List<AllSongModel>> allSong = ValueNotifier([]);

  playSong(String? uri) {
    try {
      AudioPlayerService.player.setAudioSource(
        AudioSource.uri(Uri.parse(uri!)),
      );
      AudioPlayerService.player.play();
    } on Exception {
      log("Error in parsing");
    }
  }

  @override
  void initState() {
    allSong.value = allSongNotifier.value;
    allSong.value.shuffle();
    super.initState();
  }


  void shuffleSongs() {
    allSongNotifier.value.shuffle();
    allSongNotifier.notifyListeners(); // Notify the change to the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: shuffleSongs,
            icon: const Icon(Icons.shuffle_rounded),
          )
        ],
        title: const Text(
          "Shuffle",
          style: TextStyle(color: white),
        ),
        iconTheme: const IconThemeData(color: white),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ValueListenableBuilder<List<AllSongModel>>(
          valueListenable: allSongNotifier,
          builder: (context, value, child) {
            if (value.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              shrinkWrap: true,
              //physics: const NeverScrollableScrollPhysics(),
              itemCount: value.length,
              itemBuilder: (BuildContext context, int index) {
                return musicCard(
                  queryArtWidget: QueryArtworkWidget(
                    artworkWidth: 50,
                    artworkHeight: 50,
                    artworkFit: BoxFit.fill,
                    id: value[index].id!,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      size: 30,
                      color: white,
                    ),
                  ),
                  musicName: value[index].displayNameWOExt,
                  artistName: value[index].artist,
                  operation: () {
                    Get.to(
                      () => ScreenPlaying(
                        songModelList: value,
                        idx: index,
                      ),
                      transition: Transition.cupertino,
                      duration: const Duration(seconds: 1),
                    );
                  },
                  PopupMenuButton: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: const Text("Add to favorite"),
                          onTap: () {
                            songAdtoFavorite(value[index],_audioQuery);
                          },
                        ),
                        PopupMenuItem(
                          child: const Text("Add to playlist"),
                          onTap: () {
                            Get.to(() => ScreenSelecte(),
                                transition: Transition.cupertino,
                                duration: const Duration(milliseconds: 500));
                          },
                        )
                      ];
                    },
                    iconColor: white,
                  ),
                  context: context,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
