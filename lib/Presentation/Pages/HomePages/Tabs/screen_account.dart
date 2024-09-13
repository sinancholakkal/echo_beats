import 'package:echo_beats_music/Presentation/Pages/Settigs/settings.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ScreenAccount extends StatelessWidget {
  ScreenAccount({super.key});

  List images = [
    "asset/image/gamer.png",
    "asset/image/man.png",
    "asset/image/woman (1).png",
    "asset/image/woman.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:
            BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              sizeBox(h: 40),
              //Settings Button-----------------------
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Get.to(() => const ScreenSettings(),
                        transition: Transition.cupertino,
                        duration: const Duration(seconds: 1));
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: white,
                    size: 30,
                  ),
                ),
              ),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage("asset/image/profile.jpg"),
                  ),
                  Positioned(
                    left: 100,
                    top: 90,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_a_photo,
                        color:
                            Theme.of(context).buttonTheme.colorScheme!.primary,
                      ),
                    ),
                  ),
                ],
              ),
              sizeBox(h: 20),
              SizedBox(
                child: Column(
                  children: [
                    //Name-------------------------------------------
                    TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: white),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: white))),
                    ),
                    //bio--------------------
                    TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                          labelText: "Bio",
                          labelStyle: TextStyle(color: white),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: white))),
                    )
                  ],
                ),
              ),

              sizeBox(h: 10),
              //Edit button ---------------------------------
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white)),
                  onPressed: () {
                    showDialogForCreatePlaylist(context);
                  },
                  child: Text("Edit"))
            ],
          ),
        ),
      ),
    );
  }

  //Show alert box for edit profile
  void showDialogForCreatePlaylist(context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: const Text("Edit Profile"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: white),
                    labelText: "Name",
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: white),
                    labelText: "Bio",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: white),
                  )),
              ElevatedButton(
                onPressed: () {},
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
