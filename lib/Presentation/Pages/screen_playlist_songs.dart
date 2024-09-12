import 'dart:typed_data';

import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:echo_beats_music/database/functions/favourite/db_function.dart';
import 'package:echo_beats_music/database/functions/playlist/db_function_playlist.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenPlaylistSongs extends StatelessWidget {
  List<PlayListSongModel> musics;
  String playlistName;
  int indexOfPlaylist;
  ScreenPlaylistSongs(
      {super.key, required this.musics, required this.playlistName, required this.indexOfPlaylist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: white),
        title: Text(
          playlistName,
          style: const TextStyle(color: white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          //gradient: AppColors.background,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ValueListenableBuilder(
            valueListenable: playlistsNotifier,
            builder: (BuildContext context, value, Widget? child) {
              List<PlayListSongModel> songs = value[indexOfPlaylist].songs;
              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: StretchMotion(),
                      children: [
                        //slidable------------------
                        SlidableAction(
                          onPressed: (context) {
                            Uint8List? imagebyte;
                            PlayListSongModel playListSongModel =
                                PlayListSongModel(
                              id: songs[index].id,
                              displayNameWOExt: songs[index].displayNameWOExt,
                              artist: songs[index].album ?? "Unknown Artist",
                              uri: songs[index].uri,
                              imageUri: imagebyte ?? Uint8List(0), songPath: songs[index].songPath,
                            );
                            removeSongFromPlaylist(
                                playlistName, playListSongModel);
                          },
                          icon: Icons.remove_circle,
                          label: "Remove",
                        ),
                      ],
                    ),
                    //Music card for displaying each songs
                    child: musicCard(
                      queryArtWidget: QueryArtworkWidget(
                        id: songs[index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          size: 50,
                        ),
                      ),
                      musicName: songs[index].displayNameWOExt,
                      artistName: songs[index].artist,
                      operation: () async {
                        AudioPlayerService.player.stop();
          
                        // Create the proper AudioSource with MediaItem
                        await AudioPlayerService.player.setAudioSource(
                          AudioSource.uri(
                            Uri.parse(musics[index].uri!),
                            tag: MediaItem(
                                id: songs[index].id.toString(),
                                title: songs[index].displayNameWOExt,
                                artist: songs[index].artist),
                          ),
                        );
                        Get.to(() => ScreenPlaying(
                              // audioPlayer: _audioPlayer,
                              idx: index,
                              songModelList: songs,
                            ));
          
                        //Start playback
                        //await AudioPlayerService.player.play();
                      },
                      context: context,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
