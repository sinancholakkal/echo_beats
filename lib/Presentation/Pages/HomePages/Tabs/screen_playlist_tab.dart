import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class PlaylistTab extends StatelessWidget {
   PlaylistTab({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              //Create new Playlist-------------------
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
              //PlayLists-----------------
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "My Playlists (1)",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18, color: white),
                ),
              ),
              sizeBox(h: 10),
              Column(
                children: List.generate(1, (index) {
                  return ListTile(
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
                        Icons.music_note,
                        size: 40,
                        color: white,
                      ),
                    ),
                    title: const Text("Tamil songs"),
                    subtitle: const Text("2 songs"),
                    onTap: () {},
                  );
                }),
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
            content: TextFormField(),
            actions: [
              TextButton(onPressed: () {
                Get.back();
              }, child: const Text("Cancel",style: TextStyle(color: Colors.white),)),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.appNameColor
                  )
                ),
                onPressed: () {},
                child: const Text("Ok",style: TextStyle(color: white),),
              )
            ],
          );
        });
  }
}
