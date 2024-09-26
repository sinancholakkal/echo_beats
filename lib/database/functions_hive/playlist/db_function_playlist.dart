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
  await playlistBox.put(key, newPlaylist);
  playlistsNotifier.value.add(newPlaylist);
     playlistsNotifier.notifyListeners();
  
}

Future<void> gettingPlaylist() async {
  final db = await Hive.openBox<Playlist>('playlistbox');
 playlistsNotifier.value = db.values.toList();
   playlistsNotifier.notifyListeners();
}

//AddSong to playlist
Future<void> addSongToPlaylist(
    String playlistName, PlayListSongModel song) async {
  final openedBox = await Hive.openBox<Playlist>('playlistbox');

  final playlist = openedBox.values.firstWhere(
    (playlist) => playlist.name == playlistName,
  );

  List<PlayListSongModel> updatedSongs = List<PlayListSongModel>.from(playlist.songs);
  updatedSongs.add(song);
  playlist.songs = updatedSongs;
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

//update playlist name
Future<void> updatePlaylistName(int id, newPlaylistName)async{
  final openedBOX = await Hive.openBox<Playlist>("playlistbox");
  Playlist? playlist = openedBOX.get(id);
  if(playlist!=null){
    var updatePlaylist = Playlist(name: newPlaylistName,songs: playlist.songs);
    updatePlaylist.id =id;
    await openedBOX.put(id, updatePlaylist);
    
  }else{
    print("null--------------------------");
  }
  gettingPlaylist();
}