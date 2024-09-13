import 'dart:developer';
import 'dart:io';

import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
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

  ValueNotifier<List<SongModel>> allSong = ValueNotifier([]);

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
    super.initState();
    fetchSongs();
  }

  // Function to fetch songs only once
  void fetchSongs() async {
    List<SongModel> songs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    songs.shuffle();
    allSong.value = songs;
    songCount.value = songs.length;
  }

  void shuffleSongs() {
    allSong.value.shuffle();
    allSong.notifyListeners(); // Notify the change to the UI
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
        child: ValueListenableBuilder<List<SongModel>>(
          valueListenable: allSong,
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
                    id: value[index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      size: 30,
                      color: white,
                    ),
                  ),
                  musicName: value[index].displayNameWOExt,
                  artistName: "${value[index].artist}",
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
                         PopupMenuItem(child: const Text("Delete"),onTap: (){
                          String? songPath =value[index].data;
                          // deleteSong(songPath);
                          showDelete(context: context, title: "Delete", content: """Delete '${value[index].displayName}'""", playlistName: "", delete: () { 
                            deleteSong(songPath);
                            
                            Get.back();
                            setState(() {
                              
                            });
                           },);
                        },),
                        PopupMenuItem(
                          child: const Text("Add to favorite"),
                          onTap: () {},
                        ),
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
