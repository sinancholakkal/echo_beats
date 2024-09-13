
import 'package:echo_beats_music/Presentation/Pages/pppp.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_favourate.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Pages/Settigs/settings.dart';
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
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  TextEditingController searchController = TextEditingController();
  late List<ValueNotifier<bool>> playPauseList;
  String? filter;

  @override
  void initState() {
    super.initState();
    // Initialize playPauseList with an empty list
    playPauseList = [];
    gettingRecentlyPlayedSong();
    searchController.addListener((){
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => const Ppp(),
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
                txtControl: searchController,
                onTap: () {
                  // Get.to(() => const ScreenSearch(),
                  //     transition: Transition.cupertino,
                  //     duration: const Duration(seconds: 1));
                },
                showCursor: true,
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
              const Align(
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
                  final revers =value.reversed.toList();
                  // Update playPauseList if the length has changed
                  if (playPauseList.length != value.length) {
                    playPauseList = List.generate(
                        value.length, (index) => ValueNotifier<bool>(false));
                  }
                  
                  if (value.isEmpty) {
                    return const Center(
                      child: Text("No Song played"),
                    );
                  } else {
                    //Chekking for searching
                    List<RecentlyPlayedModel> filterList =[];
                    if(filter!=null && filter!.isNotEmpty){
                      filterList = revers
                        .where((song) => song.displayNameWOExt
                            .toLowerCase()
                            .contains(filter!.toLowerCase()))
                        .toList();
                        
                    }else{
                      filterList =revers;
                    }
                    if(filterList.isEmpty){
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            width: 160,
                            image: NetworkImage(
                              "https://cdn.pixabay.com/photo/2014/04/03/09/57/detective-309445_1280.png",
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("No search results")
                        ],
                      );
                    }else{
                      return filterList.isEmpty ? const Center(child: CircularProgressIndicator(),) :
                      Column(
                      children: List.generate(
                        filterList.length,
                        (index) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: playPauseList[index],
                            builder: (BuildContext context, bool isPlaying,
                                Widget? child) {
                              return musicCard(
                                queryArtWidget: QueryArtworkWidget(
                                  id: filterList[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Icon(
                                    Icons.music_note,
                                    size: 30,
                                    color: white,
                                  ),
                                ),
                                musicName: filterList[index].displayNameWOExt,
                                artistName: filterList[index].artist,
                                operation: () {
                                  //Navigating to playing screen
                                  Get.to(
                                      () => ScreenPlaying(
                                            idx: index,
                                            songModelList: filterList,
                                          ),
                                      transition: Transition.downToUp,
                                      duration: const Duration(milliseconds: 500));
                                },
                                context: context,
                              );
                            },
                          );
                        },
                      ),
                    );
                    } 
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
