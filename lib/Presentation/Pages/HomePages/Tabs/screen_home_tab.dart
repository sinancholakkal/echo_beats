import 'dart:typed_data';
import 'package:echo_beats_music/Presentation/Pages/Settigs/settings.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_add_playlist.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_favourate.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_shuffle.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:echo_beats_music/database/functions_hive/all_songs/db_function.dart';
import 'package:echo_beats_music/database/functions_hive/favourite/db_function.dart';
import 'package:echo_beats_music/database/functions_hive/recentlyPlayed/db_function_recently_played.dart';
import 'package:echo_beats_music/database/models/allsongs/all_song_model.dart';
import 'package:echo_beats_music/database/models/favourite/favourite_class_model.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:echo_beats_music/database/models/recentlyPlayed/recently_played_model.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  TextEditingController searchController = TextEditingController();
  final _audioQuery = OnAudioQuery();
  ValueNotifier<List<SongModel>> allSong = ValueNotifier([]);
  ValueNotifier<String> songHead = ValueNotifier("All Songs");
  ValueNotifier<String> username = ValueNotifier<String>('');
  final TextEditingController updatingController = TextEditingController();
  List<SongModel> songs = [];
  //String? filter;
  ValueNotifier<String> filter = ValueNotifier<String>('');

  // Function to fetch songs
  void fetchSongs() async {
    songs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    addToAllsong(songs);
  }

  @override
  void initState() {
    super.initState();
    getUsername();
    fetchSongs();
    gettingRecentlyPlayedSong();
    songHead.value =
        recentlyplayedNotifier.value.isEmpty ? "All Songs" : "Recently played";

    // Add a listener to update songHead whenever recentlyplayedNotifier changes
    recentlyplayedNotifier.addListener(() {
      if (recentlyplayedNotifier.value.isEmpty) {
        songHead.value = "All Songs";
      } else {
        songHead.value = "Recently played";
      }
    });
    searchController.addListener(() {
      filter.value = searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchSongs();

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Settings Button
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
              // Greeting Text
              Align(
                alignment: Alignment.topLeft,
                child: ValueListenableBuilder(
                  valueListenable: username,
                  builder: (BuildContext context, value, Widget? child) {
                    value = value.isEmpty ? "Noob" : value;
                    return InkWell(
                      onDoubleTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alertWithtext(
                                  ok: () {
                                    updateName();
                                    Get.back();
                                  },
                                  content: TextFormField(
                                    controller: updatingController,
                                  ),
                                  context: context);
                            });
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Hi There,\n",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: AppColors.appNameColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: value,
                              style: const TextStyle(
                                height: 1.5,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              sizeBox(h: 30),
              // Search Field
              searchField(
                txtControl: searchController,
                onTap: () {},
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
              // Song Head Text
              Align(
                alignment: Alignment.topLeft,
                child: ValueListenableBuilder(
                  valueListenable: songHead,
                  builder: (BuildContext context, value, Widget? child) {
                    return Text(
                      value,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: white),
                    );
                  },
                ),
              ),
              // Recently Played Songs
              sizeBox(h: 16),
              // ValueListenableBuilder(
              //   valueListenable: filter,
              //   builder: (BuildContext context, filterValue, Widget? child) {
              //     return ValueListenableBuilder<List<RecentlyPlayedModel>>(
              //       valueListenable: recentlyplayedNotifier,
              //       builder: (BuildContext context, value, Widget? child) {
              //         final revers = value.reversed.toList();

              //         // Check if there are recently played songs
              //         if (revers.isEmpty) {
              //           if (songs.length ==0) {
              //             return const Center(
              //               child: Text("No Song"),
              //             );
              //           } else {
              //             // Filter All Songs based on search input
              //             List<dynamic> filterListAll =
              //                 filterValue != null && filterValue!.isNotEmpty
              //                     ? songs
              //                         .where((song) => song.displayNameWOExt
              //                             .toLowerCase()
              //                             .contains(filterValue!.toLowerCase()))
              //                         .toList()
              //                     : songs;

              //             // Handle empty search results
              //             if (filterListAll.isEmpty) {
              //               return const Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   Image(
              //                     width: 160,
              //                     image: NetworkImage(
              //                       "https://cdn.pixabay.com/photo/2014/04/03/09/57/detective-309445_1280.png",
              //                     ),
              //                   ),
              //                   SizedBox(height: 20),
              //                   Text("No search results"),
              //                 ],
              //               );
              //             }

              //             // Display All Songs
              //             return Column(
              //               children: List.generate(
              //                 filterListAll.length,
              //                 (index) {
              //                   return musicCard(
              //                     queryArtWidget: QueryArtworkWidget(
              //                       id: filterListAll[index].id,
              //                       type: ArtworkType.AUDIO,
              //                       nullArtworkWidget: const Icon(
              //                         Icons.music_note,
              //                         size: 30,
              //                         color: white,
              //                       ),
              //                     ),
              //                     musicName: filterListAll[index].title,
              //                     artistName: filterListAll[index].artist ??
              //                         "Unknown Artist",
              //                     operation: () {
              //                       // Navigating to playing screen
              //                       Get.to(
              //                         () => ScreenPlaying(
              //                           idx: index,
              //                           songModelList: filterListAll,
              //                         ),
              //                         transition: Transition.downToUp,
              //                         duration:
              //                             const Duration(milliseconds: 500),
              //                       );
              //                     },
              //                     context: context,
              //                   );
              //                 },
              //               ),
              //             );
              //           }
              //         } else {
              //           // Filter Recently Played Songs based on search input
              //           List<RecentlyPlayedModel> filterList =
              //               filterValue != null && filterValue!.isNotEmpty
              //                   ? revers
              //                       .where((song) => song.displayNameWOExt
              //                           .toLowerCase()
              //                           .contains(filterValue!.toLowerCase()))
              //                       .toList()
              //                   : revers;

              //           // Handle empty search results
              //           if (filterList.isEmpty) {
              //             return const Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Image(
              //                   width: 160,
              //                   image: NetworkImage(
              //                     "https://cdn.pixabay.com/photo/2014/04/03/09/57/detective-309445_1280.png",
              //                   ),
              //                 ),
              //                 SizedBox(height: 20),
              //                 Text("No search results"),
              //               ],
              //             );
              //           }

              //           // Display Recently Played Songs
              //           return Column(
              //             children: List.generate(
              //               filterList.length,
              //               (index) {
              //                 return musicCard(
              //                   queryArtWidget: QueryArtworkWidget(
              //                     id: filterList[index].id,
              //                     type: ArtworkType.AUDIO,
              //                     nullArtworkWidget: const Icon(
              //                       Icons.music_note,
              //                       size: 30,
              //                       color: white,
              //                     ),
              //                   ),
              //                   musicName: filterList[index].displayNameWOExt,
              //                   artistName: filterList[index].artist,
              //                   PopupMenuButton:
              //                       PopupMenuButton(itemBuilder: (context) {
              //                     return [
              //                       //It is for add song into playlist
              //                       PopupMenuItem(
              //                         child: Text("Add to playlist"),
              //                         onTap: () {
              //                           List<dynamic> songs = [];
              //                           songs.add(filterList[index]);
              //                           Get.to(() => ScreenAddPlaylist(
              //                               songModel: songs));
              //                         },
              //                       ),
              //                       PopupMenuItem(
              //                         child: Text("Add to favorite"),
              //                         onTap: () {
              //                           songAdtoFavorite(filterList[index]);
              //                         },
              //                       )
              //                     ];
              //                   }),
              //                   operation: () {
              //                     // Navigating to playing screen
              //                     Get.to(
              //                       () => ScreenPlaying(
              //                         idx: index,
              //                         songModelList: filterList,
              //                       ),
              //                       transition: Transition.downToUp,
              //                       duration: const Duration(milliseconds: 500),
              //                     );
              //                   },
              //                   context: context,
              //                 );
              //               },
              //             ),
              //           );
              //         }
              //       },
              //     );
              //   },
              // ),
              ValueListenableBuilder(
                valueListenable: filter,
                builder: (BuildContext context, filterValue, Widget? child) {
                  return ValueListenableBuilder<List<RecentlyPlayedModel>>(
                    valueListenable: recentlyplayedNotifier,
                    builder: (BuildContext context, value, Widget? child) {
                      final revers =
                          value.reversed.toList(); // Recently played songs

                      // Check if there are any songs (All Songs or Recently Played)
                      if (songs.isEmpty && revers.isEmpty) {
                        return const Center(
                          child: Text("No Song"), // No songs in both lists
                        );
                      }

                      // Check for Recently Played first
                      if (revers.isEmpty) {
                        // Filter All Songs based on search input
                        List<dynamic> filterListAll =
                            filterValue != null && filterValue!.isNotEmpty
                                ? songs
                                    .where((song) => song.displayNameWOExt
                                        .toLowerCase()
                                        .contains(filterValue!.toLowerCase()))
                                    .toList()
                                : songs;

                        if (filterListAll.isEmpty) {
                          // Handle empty search result
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                width: 160,
                                image: NetworkImage(
                                    "https://cdn.pixabay.com/photo/2014/04/03/09/57/detective-309445_1280.png"),
                              ),
                              SizedBox(height: 20),
                              Text("No search results"),
                            ],
                          );
                        }

                        // Display all songs
                        return Column(
                          children: List.generate(
                            filterListAll.length,
                            (index) {
                              return musicCard(
                                queryArtWidget: QueryArtworkWidget(
                                  id: filterListAll[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Icon(
                                    Icons.music_note,
                                    size: 30,
                                    color: white,
                                  ),
                                ),
                                musicName: filterListAll[index].title,
                                artistName: filterListAll[index].artist ??
                                    "Unknown Artist",
                                operation: () {
                                  // Navigating to playing screen
                                  Get.to(
                                    () => ScreenPlaying(
                                      idx: index,
                                      songModelList: filterListAll,
                                    ),
                                    transition: Transition.downToUp,
                                    duration: const Duration(milliseconds: 500),
                                  );
                                },
                                context: context,
                              );
                            },
                          ),
                        );
                      } else {
                        // Recently Played Songs section
                        List<RecentlyPlayedModel> filterList =
                            filterValue != null && filterValue!.isNotEmpty
                                ? revers
                                    .where((song) => song.displayNameWOExt
                                        .toLowerCase()
                                        .contains(filterValue!.toLowerCase()))
                                    .toList()
                                : revers;

                        if (filterList.isEmpty) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                width: 160,
                                image: NetworkImage(
                                    "https://cdn.pixabay.com/photo/2014/04/03/09/57/detective-309445_1280.png"),
                              ),
                              SizedBox(height: 20),
                              Text("No search results"),
                            ],
                          );
                        }

                        return Column(
                          children: List.generate(
                            filterList.length,
                            (index) {
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
                                PopupMenuButton:
                                    PopupMenuButton(itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text("Add to playlist"),
                                      onTap: () {
                                        List<dynamic> songs = [];
                                        songs.add(filterList[index]);
                                        Get.to(() => ScreenAddPlaylist(
                                            songModel: songs));
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: Text("Add to favorite"),
                                      onTap: () {
                                        songAdtoFavorite(filterList[index]);
                                      },
                                    )
                                  ];
                                }),
                                operation: () {
                                  Get.to(
                                    () => ScreenPlaying(
                                      idx: index,
                                      songModelList: filterList,
                                    ),
                                    transition: Transition.downToUp,
                                    duration: const Duration(milliseconds: 500),
                                  );
                                },
                                context: context,
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void songAdtoFavorite(var song) async {
    Uint8List? imagebyte;
    if (!isAlreadyFav(song)) {
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
    } else {
      showAddedToast(msg: "This song already exists in the favorite");
    }
  }

  bool isAlreadyFav(var song) {
    return favouriteClassModelList.value.any((item) {
      return item.id == song.id;
    });
  }

  //getting name from shared preference
  Future<void> getUsername() async {
    SharedPreferences prfrs = await SharedPreferences.getInstance();
    username.value = prfrs.getString("username")!;
    updatingController.text = username.value;
    username.notifyListeners();
  }

  //updating name
  Future<void> updateName() async {
    SharedPreferences prfs = await SharedPreferences.getInstance();
    prfs.setString('username', updatingController.text);
    username.value = updatingController.text;
    showAddedToast(msg: "Name updated");
  }
}
