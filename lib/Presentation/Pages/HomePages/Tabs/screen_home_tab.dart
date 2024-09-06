import 'package:echo_beats_music/Presentation/Pages/HomePages/Tabs/screen_music_tab.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_favourate.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Pages/Settigs/settings.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_search.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_shuffle.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:echo_beats_music/database/functions/recentlyPlayed/db_function_recently_played.dart';
import 'package:echo_beats_music/database/models/recentlyPlayed/recently_played_model.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
    // Initialize playPauseList with an empty list
    playPauseList = [];
    gettingRecentlyPlayedSong();
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
              // Search Field
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
                  // Shuffle Button
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
                  // Favorite Button
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
              sizeBox(h: 16),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                    "Last Session",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: white),
                  ),
              ),
              // Recently Played Songs
              sizeBox(h: 16),
              ValueListenableBuilder<List<RecentlyPlayedModel>>(
                valueListenable: recentlyplayedNotifier,
                builder: (BuildContext context, value, Widget? child) {
                  // Update playPauseList if the length has changed
                  if (playPauseList.length != value.length) {
                    playPauseList = List.generate(
                        value.length, (index) => ValueNotifier<bool>(false));
                  }
                  if (value.isEmpty ) {
                    return Center(
                      child: Text("No Song played"),
                    );
                  } else {
                    final revers = value.reversed.toList();
                    return Column(
                      children: List.generate(
                        revers.length,
                        (index) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: playPauseList[index],
                            builder: (BuildContext context, bool isPlaying,
                                Widget? child) {
                              return musicCard(
                                queryArtWidget: QueryArtworkWidget(
                                  id: revers[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Icon(
                                    Icons.music_note,
                                    size: 30,
                                    color: white,
                                  ),
                                ),
                                musicName: revers[index].displayNameWOExt,
                                artistName: revers[index].artist,
                                operation: () {},
                                IconButton: IconButton(
                                  onPressed: () {
                                    if (_currenyPlayingIndex != -1 &&
                                        _currenyPlayingIndex != index) {
                                      playPauseList[_currenyPlayingIndex]
                                          .value = false;
                                    }
                                    playPauseList[index].value = !isPlaying;
                                    _currenyPlayingIndex = index;
                                  },
                                  icon: Icon(
                                    isPlaying
                                        ? Icons.pause_circle
                                        : Icons.play_circle,
                                    color: white,
                                    size: 40,
                                  ),
                                ),
                                context: context,
                              );
                            },
                          );
                        },
                      ),
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
}
