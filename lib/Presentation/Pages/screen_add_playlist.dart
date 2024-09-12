import 'dart:typed_data';

import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/database/functions/playlist/db_function_playlist.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';


class ScreenAddPlaylist extends StatelessWidget {
  final dynamic songModel;
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
                        print(songModel);
                        showDialogForCreatePlaylist(context);
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
                              PlayListSongModel playListSongModel =
                                  PlayListSongModel(
                                id: songModel.id,
                                displayNameWOExt: songModel.displayNameWOExt,
                                artist: songModel.album ?? "Unknown Artist",
                                uri: songModel.uri,
                                imageUri: imagebyte ?? Uint8List(0), songPath: songModel.data,
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
                                  msg: '''1 songs added to "${value[index].name}"''',
                                  backgroundColor: toastbgColor
                                );
                                print("Song not there");
                                addSongToPlaylist(
                                    value[index].name, playListSongModel);
                              }

                              print("Music added");
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

  void showDialogForCreatePlaylist(context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Create New Playlist"),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: _playlistTextController,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Enter Playlist Name";
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
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
                    createPlayList(playlistName: _playlistTextController.text);
                    Navigator.of(context).pop();
                    _playlistTextController.clear();
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
}
