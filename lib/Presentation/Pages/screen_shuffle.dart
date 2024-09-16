import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
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
    allSong.value =allSongNotifier.value;
    allSong.value.shuffle();
    super.initState();
   // fetchSongs();
  }

  // Function to fetch songs only once
  // void fetchSongs() async {
  //   List<SongModel> songs = await _audioQuery.querySongs(
  //     sortType: null,
  //     orderType: OrderType.ASC_OR_SMALLER,
  //     uriType: UriType.EXTERNAL,
  //     ignoreCase: true,
  //   );
  //   songs.shuffle();
  //   allSong.value = songs;
  //   songCount.value = songs.length;
  // }

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
        child: ValueListenableBuilder<List<AllSongModel>>(
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
                    id: value[index].id!,
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
                          String? songPath =value[index].songPath;
                          // deleteSong(songPath);
                          showDelete(context: context, title: "Delete Song", content: """Are you sure you want to delete this song permanently? '${value[index].displayNameWOExt}'""", playlistName: "", delete: () { 
                            deleteSong(songPath);
                            
                            Get.back();
                            // setState(() {
                              
                            // });
                           },);
                        },),
                        PopupMenuItem(
                          child: const Text("Add to favorite"),
                          onTap: () {
                            songAdtoFavorite(value[index]);
                          },
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
  void songAdtoFavorite(var song) async {
    Uint8List? imagebyte;
    if(!isAlreadyFav(song)){
      if (await _audioQuery.queryArtwork(song.id, ArtworkType.AUDIO) != null) {
      imagebyte = await _audioQuery.queryArtwork(song.id, ArtworkType.AUDIO);
    }
    final result = SongModelClass(
        id: song.id,
        displayNameWOExt: song.displayNameWOExt,
        artist: song.artist ?? "unknown",
        uri: song.uri,
        imageUri: imagebyte ?? Uint8List(0),
        songPath: song is RecentlyPlayedModel ||
                song is PlayListSongModel ||
                song is AllSongModel
            ? song.songPath
            : song.data);
    //Adding song in favoraited
    addSongToFavourite(result);
    showAddedToast(msg: "Favorited");
    }else{
      showAddedToast(msg: "This song already exists in the favorite");
    }
  }

  bool isAlreadyFav(var song){
    return favouriteClassModelList.value.any((item){
      return item.id == song.id;
    });
  }
}
