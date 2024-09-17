import 'package:echo_beats_music/Presentation/Pages/screen_playlist_songs.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/database/functions_hive/playlist/db_function_playlist.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';

class PlaylistTab extends StatelessWidget {
  PlaylistTab({super.key});

  final TextEditingController _playlistTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    gettingPlaylist();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              sizeBox(h: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Playlists",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: white),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialogForCreatePlaylist(context);
                      },
                      icon: const Icon(
                        Icons.add,
                        color: white,
                        size: 40,
                      ))
                ],
              ),
              sizeBox(h: 12),
              // Create new Playlist
              ListTile(
                titleTextStyle: const TextStyle(
                    color: white, fontWeight: FontWeight.bold, fontSize: 18),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey, // Top color
                        Color.fromARGB(255, 19, 117, 198), // Bottom color
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 40,
                    color: white,
                  ),
                ),
                title: const Text("Create new playlist"),
                onTap: () {
                  showDialogForCreatePlaylist(context);
                },
              ),
              sizeBox(h: 36),
              // PlayLists
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "My Playlists",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18, color: white),
                ),
              ),
              sizeBox(h: 10),
              // Replace List.generate with ListView.builder
              ValueListenableBuilder(
                valueListenable: playlistsNotifier,
                builder: (BuildContext context, value, Widget? child) {
                  if (value.isEmpty) {
                    return const Center(
                      child: Text(
                        "No PlayList",
                        style: TextStyle(color: white),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        //final playlist = playlists[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                //slidable------------------
                                SlidableAction(
                                  onPressed: (context) {
                                    showDelete(
                                      context: context,
                                      content:
                                          """Are you sure you want to delete the playlist '${value[index].name}'?""",
                                      title: "Delete Playlist",
                                      //key: value[index].id!,
                                      playlistName: '',
                                      delete: () {
                                        deletePlaylist(value[index].id!);
                                        Get.back();
                                        showAddedToast(
                                            msg:
                                                "Playlist '${value[index].name}' deleted successfully");
                                      },
                                    );
                                  },
                                  icon: Icons.remove_circle,
                                  label: "Remove",
                                ),
                                //Edit button for edit name playlist--------------
                                SlidableAction(
                                  onPressed: (context) {
                                    int? key = value[index].id;
                                    print(key);
                                    print(value[index].name);
                                    _playlistTextController.text =
                                        value[index].name;
                                    showDialogForCreatePlaylist(context,
                                        id: key);

                                  },
                                  icon: Icons.edit,
                                  label: "Edit",
                                )
                              ],
                            ),
                            child: ListTile(
                              titleTextStyle: const TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              subtitleTextStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 207, 200, 200)),
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.grey, // Top color
                                      Color.fromARGB(
                                          255, 19, 117, 198), // Bottom color
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.music_note,
                                  size: 40,
                                  color: white,
                                ),
                              ),
                              //Title of playlists tab
                              title: Text(value[index].name),
                              subtitle: Text("${value[index].songs.length}"),
                              onTap: () {
                                print(
                                    "${value[index].id.runtimeType} -----------------------------------------------");
                                // Handle playlist tap
                                Get.to(() => ScreenPlaylistSongs(
                                    musics: value[index].songs,
                                    playlistName: value[index].name,
                                    indexOfPlaylist: index));
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogForCreatePlaylist(context, {int? id}) {
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
                    controllClear();
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
                    controllClear();
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

  void controllClear(){
    _playlistTextController.clear();
  }
}
