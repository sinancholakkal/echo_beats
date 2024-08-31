import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_search.dart';
import 'package:echo_beats_music/Presentation/Pages/screen_selecte.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:marquee_text/marquee_text.dart';

class MusicTab extends StatelessWidget {
  MusicTab({super.key});
  ValueNotifier<bool> listToGrid = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Search field------------
            sizeBox(h: 40),
            searchField(
              color: white,
              hint: "Search by name (4)",
              iconData: Icons.search,
              showCursor: false,
              onTap: () {
                Get.to(() => ScreenSearch(),
                    transition: Transition.cupertino,
                    duration: const Duration(seconds: 1));
              },
              type: TextInputType.none,
            ),
            sizeBox(h: 20),
            //All Songs row, in cluded sort grid and select
            Row(
              children: [
                const Text(
                  "All Songs",
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Spacer(),
                // Selected butten for delete multiple iteme--------
                IconButton(
                    onPressed: () {
                      Get.to(
                        () => ScreenSelecte(),
                        transition: Transition.cupertino,
                        duration: const Duration(seconds: 1)
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
            ValueListenableBuilder(
              valueListenable: listToGrid,
              builder: (BuildContext context, value, Widget? child) {
                return value == false
                    ? Column(
                        children: List.generate(
                          10,
                          (index) {
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
                                          artistName:
                                              "Water Packet - Video song",
                                          songName: "Sun Tv",
                                        ),
                                    transition: Transition.cupertino,
                                    duration: const Duration(seconds: 1));
                              },
                              PopupMenuButton: PopupMenuButton(
                                itemBuilder: (index) {
                                  return [
                                    const PopupMenuItem(child: Text("Delete")),
                                    const PopupMenuItem(
                                        child: Text("Add to favorate")),
                                  ];
                                },
                                iconColor: white,
                              ), context: context,
                            );
                          },
                        ),
                      )
                    : GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: List.generate(10, (index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                  () => ScreenPlaying(
                                        image:
                                            "https://i.ytimg.com/vi/RgOEKdA2mlw/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAmheQ8_nbR7Trrpapl6B7Ko0xKkw",
                                        artistName: "Water Packet - Video song",
                                        songName: "Sun Tv",
                                      ),
                                  transition: Transition.cupertino,
                                  duration: const Duration(seconds: 1));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    //color: cardColor,
                                     color: Theme.of(context).colorScheme.secondary,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                //color: white,
                                child: const Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: CircleAvatar(
                                        radius: 56,
                                        backgroundImage: NetworkImage(
                                            "https://i.ytimg.com/vi/RgOEKdA2mlw/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAmheQ8_nbR7Trrpapl6B7Ko0xKkw"),
                                      ),
                                    ),
                                    //Display music name------------------------
                                    MarqueeText(
                                      speed: 14,
                                      text: TextSpan(
                                          text: "Water Packet - Video song",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: white)),
                                    ),
                                    // Artist Name
                                    MarqueeText(
                                      speed: 14,
                                      text: TextSpan(
                                          text: "Sun Tv",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: white)),
                                    ),
                                  ],
                                )),
                          );
                        }),
                      );
              },
            ),
          ],
        ),
      ),
    ));
  }
}
