import 'package:echo_beats_music/Presentation/Pages/screen_add_playlist.dart';
import 'package:echo_beats_music/database/functions_hive/all_songs/db_function.dart';
import 'package:echo_beats_music/database/models/allsongs/all_song_model.dart';
import 'package:flutter/material.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenSelecte extends StatefulWidget {
  ScreenSelecte({super.key});

  @override
  State<ScreenSelecte> createState() => _ScreenSelecteState();
}

class _ScreenSelecteState extends State<ScreenSelecte> {
  late ValueNotifier<List<AllSongModel>> allSong;
  ValueNotifier<bool> selectAll = ValueNotifier<bool>(false);
  late List<ValueNotifier<bool>> isSelected;

  @override
  void initState() {
    super.initState();
    allSong = ValueNotifier(allSongNotifier.value);
    isSelected = List.generate(
        allSong.value.length, (index) => ValueNotifier<bool>(false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 179, 17, 155),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: white),
        title: const Text(
          "Song Selected",
          style: TextStyle(color: white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            //gradient: AppColors.background,
            color: Theme.of(context).scaffoldBackgroundColor),
        child: Column(
          children: [
            // Select All
            ValueListenableBuilder(
              valueListenable: selectAll,
              builder: (BuildContext context, bool value, Widget? child) {
                return ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          List<dynamic> songs=[];
                          for(int i=0;i<isSelected.length;i++){
                            if(isSelected[i].value == true){
                              songs.add(allSong.value[i]);
                            }
                          }
                          Get.to(()=>ScreenAddPlaylist(songModel: songs));
                          // Handle add playlist action
                        },
                        icon: const Icon(Icons.playlist_add, color: white),
                      ),
                    ],
                  ),
                  title: const Text(
                    "Select All",
                    style: TextStyle(
                      color: white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    selectAll.value = !value;
                    for (var i in isSelected) {
                      i.value = selectAll.value;
                    }
                  },
                  leading: Icon(
                    value ? Icons.check_box : Icons.check_box_outline_blank,
                    color: white,
                  ),
                );
              },
            ),
            // Songs item
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: allSong,
                builder: (BuildContext context, song, Widget? child) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: song.length,
                    itemBuilder: (context, index) {
                      return ValueListenableBuilder(
                        valueListenable: isSelected[index],
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return ListTile(
                            leading: IconButton(onPressed: (){
                              isSelected[index].value = !value;
                            }, icon: Icon(value? Icons.check_box : Icons.check_box_outline_blank)),
                            title: musicCard(
                              queryArtWidget: QueryArtworkWidget(
                                id: song[index].id!,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note,
                                  size: 30,
                                  color: white,
                                ),
                              ),
                              musicName: song[index].displayNameWOExt,
                              artistName: song[index].artist,
                              operation: () {},
                              context: context,
                            ),
                            onTap: () {
                              //isSelected[index].value = !value;
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
