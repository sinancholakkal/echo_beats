
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenShuffle extends StatelessWidget {
  const ScreenShuffle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shuffle",
          style: TextStyle(color: white),
        ),
        iconTheme: const IconThemeData(color: white),
        centerTitle: true,
        // backgroundColor: const Color.fromARGB(255, 179, 17, 155),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          //gradient: AppColors.background,
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              //Music List----------------------------------------------
              children: List.generate(10, (index) {
                return musicCard(
                 queryArtWidget: QueryArtworkWidget(id: 1, type: ArtworkType.AUDIO),
                  musicName: "Katchi Sera",
                  artistName: "Sai Abhyankkar",
                  PopupMenuButton: PopupMenuButton(
                    itemBuilder: (index) {
                      return [
                        const PopupMenuItem(
                          child: Text("Delete"),
                        ),
                        const PopupMenuItem(child: Text("Add Favourate"))
                      ];
                    },
                    iconColor: white,
                  ),
                  //Passing data to playing Screen
                  operation: () {
                    // Get.to(
                    //     () => ScreenPlaying(
                    //           image:
                    //               "https://m.timesofindia.com/photo/107219750/size-193191/107219750.jpg",
                    //           artistName: "Sai Abhyankkar",
                    //           songName: "Katchi Sera",
                    //         ),
                    //     transition: Transition.cupertino,
                    //     duration: const Duration(seconds: 1));
                  },
                  context: context,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
