import 'dart:developer';
import 'package:echo_beats_music/Presentation/Pages/screen_add_playlist.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_selecte.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicTab extends StatefulWidget {
  MusicTab({super.key});

  @override
  State<MusicTab> createState() => _MusicTabState();
}

class _MusicTabState extends State<MusicTab> {
  final ValueNotifier<SongSortType?> _currentSortType = ValueNotifier(
      SongSortType
          .DISPLAY_NAME); //It is for sorting by name,time,artist and .....
  final ValueNotifier<OrderType> _currentOrderType = ValueNotifier(OrderType
      .ASC_OR_SMALLER); //It is for sorting by Ascending Order and  Descending Order
  TextEditingController searchController = TextEditingController();
  ValueNotifier<bool> listToGrid = ValueNotifier<bool>(false);
  final _audioQuery = OnAudioQuery();
  ValueNotifier<int?> songCount = ValueNotifier<int?>(null);
  List<SongModel> allSong = [];
  String? filter;

  playSong(String? uri) {
    try {
      AudioPlayerService.player.setAudioSource(
        AudioSource.uri(Uri.parse(uri!)),
      );
      AudioPlayerService.player.play();
    } on Exception {
      log("Error in parsing");
    }
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              sizeBox(h: 40),
              ValueListenableBuilder(
                valueListenable: songCount,
                builder: (BuildContext context, value, Widget? child) {
                  return searchField(
                    txtControl: searchController,
                    color: white,
                    hint: "Search by name ${value ?? ""}",
                    iconData: Icons.search,
                    showCursor: true,
                    onTap: () {},
                    type: TextInputType.none,
                  );
                },
              ),
              sizeBox(h: 20),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(
                        () => ScreenPlaying(
                          idx: 0,
                          songModelList: allSong,
                        ),
                        transition: Transition.cupertino,
                        duration: const Duration(seconds: 1),
                      );
                    },
                    icon: const Icon(
                      Icons.play_circle,
                      color: white,
                      size: 40,
                    ),
                  ),
                  const Text(
                    "All Songs",
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.to(
                        () => ScreenSelecte(),
                        transition: Transition.cupertino,
                        duration: const Duration(seconds: 1),
                      );
                    },
                    icon: const Icon(
                      Icons.checklist_outlined,
                      color: white,
                      size: 30,
                    ),
                  ),
                  //Sorting button--------------------------------
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: const Color.fromARGB(255, 93, 84, 84),
                        context: context,
                        builder: (BuildContext context) {
                          return buildBottumSheetContent();
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.sort,
                      color: white,
                      size: 30,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: listToGrid,
                    builder: (BuildContext context, value, Widget? child) {
                      return IconButton(
                        onPressed: () {
                          listToGrid.value = !value;
                        },
                        icon: Icon(
                          value == false ? Icons.grid_view : Icons.list,
                          color: white,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ],
              ),
              sizeBox(h: 20),
              ValueListenableBuilder(
                valueListenable: _currentOrderType,
                builder: (BuildContext context, orderType, Widget? child) {
                  return ValueListenableBuilder(
                    valueListenable: _currentSortType,
                    builder: (BuildContext context, sortValue, Widget? child) {
                      //Switching  song in device-----------------
                      return FutureBuilder<List<SongModel>>(
                          future: _audioQuery.querySongs(
                            sortType: sortValue,
                            orderType: orderType,
                            uriType: UriType.EXTERNAL,
                            ignoreCase: true,
                          ),
                          builder: (context, item) {
                            if (item.connectionState == ConnectionState.done) {
                              if (item.data != null) {
                                songCount.value = item.data!.length;
                              }
                            }

                            if (item.data == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (item.data!.isEmpty) {
                              return const Center(
                                child: Text("No Songs"),
                              );
                            }

                            List<SongModel> filterList = [];
                            if (filter != null && filter!.isNotEmpty) {
                              filterList = item.data!
                                  .where((song) => song.displayNameWOExt
                                      .toLowerCase()
                                      .contains(filter!.toLowerCase()))
                                  .toList();
                            } else {
                              filterList = item.data!;
                            }

                            allSong.addAll(filterList);
                            if (filterList.isNotEmpty) {
                              return ValueListenableBuilder(
                                valueListenable: listToGrid,
                                builder: (BuildContext context, value,
                                    Widget? child) {
                                  if (value == false) {
                                    // List View using ListView
                                    return ListView(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: List.generate(filterList.length,
                                          (index) {
                                        return musicCard(
                                          queryArtWidget: QueryArtworkWidget(
                                            artworkWidth: 50,
                                            artworkHeight: 50,
                                            artworkFit: BoxFit.fill,
                                            id: filterList[index].id,
                                            type: ArtworkType.AUDIO,
                                            nullArtworkWidget: const Icon(
                                              Icons.music_note,
                                              size: 30,
                                              color: white,
                                            ),
                                          ),
                                          musicName: filterList[index]
                                              .displayNameWOExt,
                                          artistName:
                                              "${filterList[index].artist}",
                                          operation: () {
                                            Get.to(
                                              () => ScreenPlaying(
                                                songModelList: filterList,
                                                idx: index,
                                              ),
                                              transition: Transition.cupertino,
                                              duration:
                                                  const Duration(seconds: 1),
                                            );
                                          },
                                          PopupMenuButton: PopupMenuButton(
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  child: const Text(
                                                      "Add to playlist"),
                                                  onTap: () {
                                                    List<dynamic> songs = [];
                                                    songs
                                                        .add(filterList[index]);
                                                    Get.to(() =>
                                                        ScreenAddPlaylist(
                                                            songModel: songs));
                                                  },
                                                ),
                                                const PopupMenuItem(
                                                    child: Text(
                                                        "Add to favorite")),
                                                const PopupMenuItem(
                                                    child: Text("Delete"))
                                              ];
                                            },
                                            iconColor: white,
                                          ),
                                          context: context,
                                        );
                                      }),
                                    );
                                  } else {
                                    // Grid View using GridView
                                    return GridView.count(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                      children: List.generate(filterList.length,
                                          (index) {
                                        return InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => ScreenPlaying(
                                                songModelList: filterList,
                                                idx: index,
                                              ),
                                              transition: Transition.cupertino,
                                              duration:
                                                  const Duration(seconds: 1),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16)),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8),
                                                  child: CircleAvatar(
                                                    radius: 56,
                                                    child: QueryArtworkWidget(
                                                      artworkWidth: 100,
                                                      artworkHeight: 100,
                                                      artworkFit: BoxFit.fill,
                                                      id: filterList[index].id,
                                                      type: ArtworkType.AUDIO,
                                                      nullArtworkWidget:
                                                          const Icon(
                                                        Icons.music_note,
                                                        size: 60,
                                                        color: white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: MarqueeText(
                                                    speed: 14,
                                                    text: TextSpan(
                                                      text: filterList[index]
                                                          .displayNameWOExt,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                MarqueeText(
                                                  speed: 14,
                                                  text: TextSpan(
                                                    text:
                                                        "${filterList[index].artist}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  }
                                },
                              );
                            } else {
                              return const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    width: 160,
                                    image: NetworkImage(
                                      "https://cdn.pixabay.com/photo/2014/04/03/09/57/detective-309445_1280.png",
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("No search results")
                                ],
                              );
                            }
                          });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

//Bottum sheet for sorting song--------------------
  Widget buildBottumSheetContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            "Sort",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          ListTile(
            title: Text(
              "By song name",
              style: TextStyle(
                  color: _currentSortType.value == SongSortType.DISPLAY_NAME
                      ? Colors.blue
                      : Colors.white),
            ),
            onTap: () {
              _currentSortType.value = SongSortType.DISPLAY_NAME;

              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              "Sort by Artist",
              style: TextStyle(
                  color: _currentSortType.value == SongSortType.ARTIST
                      ? Colors.blue
                      : Colors.white),
            ),
            onTap: () {
              _currentSortType.value = SongSortType.ARTIST;

              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              "Sort by Album",
              style: TextStyle(
                  color: _currentSortType.value == SongSortType.ALBUM
                      ? Colors.blue
                      : Colors.white),
            ),
            onTap: () {
              _currentSortType.value = SongSortType.ALBUM;

              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              "By time added(newest on top)",
              style: TextStyle(
                  color: _currentSortType.value == SongSortType.DATE_ADDED &&
                          _currentOrderType.value == OrderType.DESC_OR_GREATER
                      ? Colors.blue
                      : Colors.white),
            ),
            onTap: () {
              _currentSortType.value = SongSortType.DATE_ADDED;
              _currentOrderType.value = OrderType.DESC_OR_GREATER;

              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              "By time added(oldest on top)",
              style: TextStyle(
                  color: _currentSortType.value == SongSortType.DATE_ADDED &&
                          _currentOrderType.value == OrderType.ASC_OR_SMALLER
                      ? Colors.blue
                      : Colors.white),
            ),
            onTap: () {
              _currentSortType.value = SongSortType.DATE_ADDED;
              _currentOrderType.value = OrderType.ASC_OR_SMALLER;

              Navigator.pop(context);
            },
          )

          // Add more sorting options here
        ],
      ),
    );
  }
}
