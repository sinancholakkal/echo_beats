import 'dart:typed_data';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/database/functions_hive/playlist/db_function_playlist.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';


class ScreenAddPlaylist extends StatelessWidget {
  //final dynamic songModel;
  List<dynamic> songModel;

  ScreenAddPlaylist({super.key, required this.songModel});

  final TextEditingController _playlistTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: white),
        titleTextStyle: const TextStyle(color: white, fontSize: 20),
        title: const Text("Select Playlist"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          //gradient: AppColors.background,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "New Playlist",
                    style: TextStyle(color: white),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialogForCreatePlaylist1(context);
                      },
                      icon:const Icon(
                        Icons.add,
                        color: white,
                      ))
                ],
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: playlistsNotifier,
                  builder: (BuildContext context, value, Widget? child) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: ListTile(
                            title: Text(
                              value[index].name,
                              style: const TextStyle(color: white),
                            ),
                            subtitle: Text(
                              "${value[index].songs.length} songs",
                              style: const TextStyle(color: white),
                            ),
                            onTap: () {
                              Uint8List? imagebyte;
                              for(var song in songModel){
                                PlayListSongModel playListSongModel =
                                  PlayListSongModel(
                                id: song.id,
                                displayNameWOExt: song.displayNameWOExt,
                                artist: song.album ?? "Unknown Artist",
                                uri: song.uri,
                                imageUri: imagebyte ?? Uint8List(0), 
                                songPath: song is SongModel ? song.data : song.songPath,
                              );

                              if (value[index].songs.any((song) =>
                                  song.displayNameWOExt ==
                                  playListSongModel.displayNameWOExt)) {
                                print("Song has there");
                                Fluttertoast.showToast(
                                  backgroundColor: toastbgColor,
                                  msg:
                                      "This song already exists in the playlist",
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: '''song added to "${value[index].name}"''',
                                  backgroundColor: toastbgColor
                                );
                                print("Song not there");
                                addSongToPlaylist(
                                    value[index].name, playListSongModel);
                              }

                              print("Music added");
                              
                              }
                              Get.back();
                              
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDialogForCreatePlaylist1(context, {int? id}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: const Text("Create New Playlist"),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: _playlistTextController,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Enter Playlist Name";
                  } else if (isPlaylistNameAlreadyExists(val)) {
                    return "Playlist name already exists";
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                   // controllClear();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(AppColors.appNameColor)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("validate------------------");
                    if (id != null) {
                      updatePlaylistName(id, _playlistTextController.text);
                    } else {
                      createPlayList(
                          playlistName: _playlistTextController.text);
                          _playlistTextController.clear();
                    }
                    // controllClear();
                    Get.back();
                    
                  } else {
                    print("Not validated----------------");
                  }
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(color: white),
                ),
              )
            ],
          );
        });
  }


//Checking playlist name already exists
  bool isPlaylistNameAlreadyExists(name) {
    final allPlaylist = playlistsNotifier.value;
    for (var item in allPlaylist) {
      if (item.name == name) {
        return true;
      }
    }
    return false;
  }
}
