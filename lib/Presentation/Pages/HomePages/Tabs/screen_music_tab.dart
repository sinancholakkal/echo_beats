import 'dart:developer';

import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_search.dart';
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

class MusicTab extends StatelessWidget {
  MusicTab({super.key});
  ValueNotifier<bool> listToGrid = ValueNotifier<bool>(false);
   final _audioQuery = OnAudioQuery();
  // final AudioPlayer _audioPlayer = AudioPlayer();
  ValueNotifier<int?> songCount = ValueNotifier<int?>(null);

  List<SongModel> allSong = [];

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              sizeBox(h: 40),
              ValueListenableBuilder(
                valueListenable: songCount,
                builder: (BuildContext context, value, Widget? child) {
                  
                  return searchField(
                    color: white,
                    hint: "Search by name ${value??""}",
                    iconData: Icons.search,
                    showCursor: false,
                    onTap: () {
                      Get.to(() => const ScreenSearch(),
                          transition: Transition.cupertino,
                          duration: const Duration(seconds: 1));
                    },
                    type: TextInputType.none,
                  );
                },
              ),
              sizeBox(h: 20),
              Row(
                children: [
                  //Play all song Button----------
                  IconButton(
                      onPressed: () {
                        Get.to(
                            () => ScreenPlaying(
                              idx: 0,
                                  
                                 // audioPlayer: AudioPlayerService.player,
                                  songModelList: allSong,
                                ),
                            transition: Transition.cupertino,
                            duration: const Duration(seconds: 1));
                      },
                      icon: const Icon(
                        Icons.play_circle,
                        color: white,
                        size: 40,
                      )),
                  const Text(
                    "All Songs",
                    style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
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
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.sort,
                        color: white,
                        size: 30,
                      )),
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
                          ));
                    },
                  ),
                ],
              ),
              sizeBox(h: 20),
              FutureBuilder<List<SongModel>>(
                future: _audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, item) {
                  //Adding song count ---------------------------------
                  if (item.connectionState == ConnectionState.done) {
                    // Update the song count only when the data is loaded
                    if (item.data != null) {
                      songCount.value = item.data!.length;
                    }
                  }
                  print(item.data);
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
                  return ValueListenableBuilder(
                    valueListenable: listToGrid,
                    builder: (BuildContext context, value, Widget? child) {
                      //var songData = item.data!;
                      if (value == false) {
                        // List View
                        return ListView.builder(
                          shrinkWrap:
                              true, // Ensures the ListView doesn't take infinite height
                          physics:
                              const NeverScrollableScrollPhysics(), // Prevents ListView from scrolling
                          itemCount: item.data!
                              .length, // Replace with actual count of songs
                          itemBuilder: (BuildContext context, int index) {
                            allSong.addAll(item.data!);
                            return musicCard(
                              //Image song------------------------
                              queryArtWidget: QueryArtworkWidget(
                                artworkWidth: 50,
                                artworkHeight: 50,
                                artworkFit: BoxFit.fill,
                                id: item.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note,
                                  size: 30,
                                  color: white,
                                ),
                              ),
                              //imageProvider: QueryArtworkWidget(id: id, type: type),
                              musicName: item.data![index].displayNameWOExt,
                              artistName: "${item.data![index].artist}",
                              operation: () {
                                //playSong(item.data![index].uri);
                                Get.to(
                                    () => ScreenPlaying(
                                          
                                        // audioPlayer: AudioPlayerService.player,
                                          songModelList: item.data!,
                                          idx: index,
                                        ),
                                    transition: Transition.cupertino,
                                    duration: const Duration(seconds: 1));
                              },
                              PopupMenuButton: PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    const PopupMenuItem(child: Text("Delete")),
                                    const PopupMenuItem(
                                        child: Text("Add to favorite")),
                                  ];
                                },
                                iconColor: white,
                              ),
                              context: context,
                            );
                          },
                        );
                      } else {
                        // Grid View-------------------------------------------------
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          children: List.generate(item.data!.length, (index) {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                    () => ScreenPlaying(
                                      idx: index,
                                         //audioPlayer: AudioPlayerService.player,
                                          songModelList: allSong,
                                          
                                        ),
                                    transition: Transition.cupertino,
                                    duration: const Duration(seconds: 1));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: CircleAvatar(
                                        radius: 56,
                                        //Image gridView------------------------------------
                                        child: QueryArtworkWidget(
                                          artworkWidth: 100,
                                          artworkHeight: 100,
                                          artworkFit: BoxFit.fill,
                                          id: item.data![index].id,
                                          type: ArtworkType.AUDIO,
                                          nullArtworkWidget: const Icon(
                                            Icons.music_note,
                                            size: 60,
                                            color: white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: MarqueeText(
                                        speed: 14,
                                        text: TextSpan(
                                            text: item
                                                .data![index].displayNameWOExt,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: white)),
                                      ),
                                    ),
                                    MarqueeText(
                                      speed: 14,
                                      text: TextSpan(
                                          text: "${item.data![index].artist}",
                                          style:const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: white)),
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
