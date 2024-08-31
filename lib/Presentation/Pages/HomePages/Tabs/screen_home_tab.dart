import 'package:echo_beats_music/Presentation/Pages/screen_favourate.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Pages/Settigs/settings.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_search.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_shuffle.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late List<ValueNotifier<bool>> playPauseList;
  int _currenyPlayingIndex = -1;
  @override
  void initState() {
    super.initState();
    int length = 10;
    playPauseList =
        List.generate(length, (index) => ValueNotifier<bool>(false));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => const ScreenSettings(),
                          transition: Transition.cupertino);
                    },
                    icon: const Icon(
                      Icons.settings,
                      size: 40,
                      color: white,
                    ),
                  ),
                ],
              ),
              sizeBox(h: 30),
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Hi There,\n",
                        style: TextStyle(
                            fontSize: 30,
                            color: AppColors.appNameColor,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "Sinan",
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              sizeBox(h: 30),
              //Search Field-----------------------------
              searchField(
                onTap: () {
                  Get.to(() => ScreenSearch(),
                      transition: Transition.cupertino,
                      duration: const Duration(seconds: 1));
                },
                showCursor: false,
                color: white,
                hint: "Search",
                iconData: Icons.search,
                type: TextInputType.none,
              ),
              sizeBox(h: 30),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Music",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: white),
                ),
              ),
              sizeBox(h: 20),
              Row(
                children: [
                  //Shuffle------------------
                  homeCard(
                    color: [
                      const Color.fromARGB(255, 149, 17, 190),
                      const Color.fromARGB(255, 162, 13, 13)
                    ],
                    iconData: Icons.shuffle,
                    text: 'Shuffle',
                    onTap: () {
                      Get.to(() => ScreenShuffle(),
                          transition: Transition.cupertino);
                    },
                  ),
                  sizeBox(w: 10),
                  homeCard(
                    color: [
                      const Color.fromARGB(255, 34, 77, 220),
                      const Color.fromARGB(255, 168, 15, 15)
                    ],
                    iconData: Icons.favorite,
                    text: 'Favourite',
                    onTap: () {
                      Get.to(() => ScreenFavourate(),
                          transition: Transition.cupertino);
                    },
                  ),
                ],
              ),
              //recent played songsss
              sizeBox(h: 30),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Recently Played",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: white),
                ),
              ),
              sizeBox(h: 30),
              //recent played song card-------------------------
              Column(
                children: List.generate(10, (index) {
                  return ValueListenableBuilder(
                    valueListenable: playPauseList[index],
                    builder: (BuildContext context, bool value, Widget? child) {
                      return musicCard(
                          image:
                              "https://i.ytimg.com/vi/RgOEKdA2mlw/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAmheQ8_nbR7Trrpapl6B7Ko0xKkw",
                          musicName: "Water Packet - Video song",
                          artistName: "Sun Tv",
                          operation: () {
                            Get.to(
                              () => ScreenPlaying(
                                image:
                                    "https://i.ytimg.com/vi/RgOEKdA2mlw/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAmheQ8_nbR7Trrpapl6B7Ko0xKkw",
                                artistName: "Sun Tv",
                                songName: "Water Packet - Video song",
                              ),
                              transition: Transition.circularReveal,
                              duration: Duration(seconds: 1),
                            );
                          },
                          IconButton: IconButton(
                              onPressed: () {
                                if (_currenyPlayingIndex != -1 &&
                                    _currenyPlayingIndex != index) {
                                  playPauseList[_currenyPlayingIndex].value =
                                      false;
                                }
                                playPauseList[index].value = !value;
                                _currenyPlayingIndex = index;
                              },
                              icon: Icon(
                                //Icons.play_circle,
                                value == false
                                    ? Icons.play_circle
                                    : Icons.pause_circle,
                                color: white,
                                size: 40,
                              )), context: context);
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
