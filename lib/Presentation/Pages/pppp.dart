import 'package:echo_beats_music/database/functions/all_songs/db_function.dart';
import 'package:flutter/material.dart';

class Ppp extends StatelessWidget {
  const Ppp({super.key});

  @override
  Widget build(BuildContext context) {
    getAllSongs();
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: allSongNotifier,
          builder: (BuildContext context, value, Widget? child) {  
            return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("100"),
              );
            },
            itemCount: value.length,
          );
          },
          
        ),
      ),
    );
  }
}
