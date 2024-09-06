import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<Playlist>> playlistsNotifier = ValueNotifier([]);

Future<void> createPlayList({required String playlistName}) async {
  final newPlaylist = Playlist(name: playlistName);
  final playlistBox = await Hive.openBox<Playlist>('playlistbox');

  final key = await playlistBox.add(newPlaylist);
  newPlaylist.id = key;
  // playlistsNotifier.value = [...playlistsNotifier.value, newPlaylist];
  playlistsNotifier.value.add(newPlaylist);
     playlistsNotifier.notifyListeners();
       await playlistBox.put(key, newPlaylist);
  
}

Future<void> gettingPlaylist() async {
  final db = await Hive.openBox<Playlist>('playlistbox');
 playlistsNotifier.value = db.values.toList();
   playlistsNotifier.notifyListeners();
 //playlistsNotifier.value = db.values.cast<Playlist>().toList();

}

//AddSong to playlist
Future<void> addSongToPlaylist(
    String playlistName, PlayListSongModel song) async {
  final openedBox = await Hive.openBox<Playlist>('playlistbox');

  final playlist = openedBox.values.firstWhere(
    (playlist) => playlist.name == playlistName,
  );
  // Create a new mutable list from the unmodifiable one
  List<PlayListSongModel> updatedSongs = List<PlayListSongModel>.from(playlist.songs);
  // Add the new song
  updatedSongs.add(song);
  // Update the playlist with the new songs list
  playlist.songs = updatedSongs;
  // Save the updated playlist back to the box
  await openedBox.put(playlist.id!, playlist);
  gettingPlaylist();
}

//Remove song in the playlist
Future<void> removeSongFromPlaylist(String playlistName ,PlayListSongModel playlistSongModel) async {
  final openedDB = await Hive.openBox<Playlist>('playlistbox');
  final playlist = openedDB.values.firstWhere((playlist){
    return playlist.name == playlistName;
  });

  playlist.songs.removeWhere((song){
    return song.displayNameWOExt ==playlistSongModel.displayNameWOExt;
  });

  await openedDB.put(playlist.id, playlist);
  gettingPlaylist();
    playlistsNotifier.notifyListeners();

}

//Delete playlist by key
Future<void>deletePlaylist(int key)async{
  final openedBox = await Hive.openBox<Playlist>('playlistbox');
  openedBox.delete(key);
  gettingPlaylist();
}