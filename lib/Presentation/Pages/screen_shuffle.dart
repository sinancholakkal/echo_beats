import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenShuffle extends StatelessWidget {
   ScreenShuffle({super.key});
  final _audioQuery = OnAudioQuery();

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: FutureBuilder<List<SongModel>>(
           future: _audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
          builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) { 
            return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 10, // Replace with the actual number of items if dynamic
            itemBuilder: (context, index) {
              return musicCard(
                queryArtWidget: QueryArtworkWidget(id: 1, type: ArtworkType.AUDIO),
                musicName: "Katchi Sera",
                artistName: "Sai Abhyankkar",
                PopupMenuButton: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        child: Text("Delete"),
                      ),
                      const PopupMenuItem(child: Text("Add Favourite"))
                    ];
                  },
                  iconColor: white,
                ),
                operation: () {
                  // Add your operation code here
                },
                context: context,
              );
            },
          );
           },
          
        ),
      ),
    );
  }
}
