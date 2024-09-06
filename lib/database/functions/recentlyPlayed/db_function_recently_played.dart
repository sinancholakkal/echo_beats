
import 'package:echo_beats_music/database/models/recentlyPlayed/recently_played_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<RecentlyPlayedModel>>recentlyplayedNotifier = ValueNotifier([]);

Future<void> addRecentlyPlayed(RecentlyPlayedModel song)async{
  final openedBox = await Hive.openBox<RecentlyPlayedModel>('recentlyplayed');
      bool isAlready = recentlyplayedNotifier.value.any((item)=>item.id==song.id);
    if(isAlready==false){
      recentlyplayedNotifier.value.add(song);
    }else{
      recentlyplayedNotifier.value.removeWhere((item)=>song.id==item.id);
      recentlyplayedNotifier.value.add(song);
    }

        bool isAlreadyDB = openedBox.values.any((item)=>item.id==song.id);
    if(isAlreadyDB==false){
      openedBox.put(song.id, song);
    }else{
      openedBox.delete(song.id);
      openedBox.put(song.id, song);
    }

  if(openedBox.length>30){
    openedBox.deleteAt(0);
    
  }
  recentlyplayedNotifier.notifyListeners();


}

Future<void>gettingRecentlyPlayedSong()async{
  final openedBox = await Hive.openBox<RecentlyPlayedModel>('recentlyplayed');
  recentlyplayedNotifier.value.clear();
  final sortedList = openedBox.values.toList();
   sortedList.sort((b,a) => b.timestamp.compareTo(a.timestamp)); // Sorted by most recent
  recentlyplayedNotifier.value =sortedList;
    recentlyplayedNotifier.notifyListeners();
}