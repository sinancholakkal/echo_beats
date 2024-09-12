import 'package:echo_beats_music/Presentation/Pages/screen_playing.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:echo_beats_music/database/functions/favourite/db_function.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenFavourate extends StatelessWidget {
  ScreenFavourate({super.key});

  //final AudioPlayer _audioPlayer = AudioPlayer();
  //audioPlayerfinal _audioPlayer = AudioPlayer();

  List<dynamic> sss=[...favouriteClassModelList.value];

  @override
  Widget build(BuildContext context) {
    getAllSongFromFavourite();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favourate",
          style: TextStyle(color: white),
        ),
        iconTheme: const IconThemeData(color: white),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ValueListenableBuilder(
            valueListenable: favouriteClassModelList,
            builder: (BuildContext context, value, Widget? child) {
              if (value.isEmpty) {
                return const Center(child: Text("No favorite songs found"));
              } else {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return musicCard(
                      queryArtWidget: QueryArtworkWidget(
                          id: value[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget:const Icon(
                            Icons.music_note,
                            size: 50,
                          )),
                      musicName: value[index].displayNameWOExt,
                      artistName: value[index].artist,
                      operation: () async {
                        print("---------------------------------------------");
                        print(favouriteClassModelList.value.length);
                         AudioPlayerService.player.stop();

                        // Create the proper AudioSource with MediaItem
                        await AudioPlayerService.player.setAudioSource(
                          AudioSource.uri(
                            Uri.parse(favouriteClassModelList.value[index].uri!),
                            tag: MediaItem(
                              id: favouriteClassModelList.value[index].id
                                  .toString(),
                              title: favouriteClassModelList
                                  .value[index].displayNameWOExt,
                              artist:
                                  favouriteClassModelList.value[index].artist 
                            ),
                          ),
                        );
                        Get.to(() => ScreenPlaying(
                              idx: index,
                              songModelList: favouriteClassModelList.value,
                            ));

                        //Start playback
                        //await AudioPlayerService.player.play();
                      },
                      //Favorite button for remove song from favorite list
                      IconButton: IconButton(
                        onPressed: () {
                          deleteFromFavorite(value[index].id);
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: white,
                          size: 30,
                        ),
                      ),
                      context: context,
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
