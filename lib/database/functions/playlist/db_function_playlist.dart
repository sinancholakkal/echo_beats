import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<Playlist>> playlistsNotifier = ValueNotifier([]);

Future<void> createPlayList({required playlistName}) async {
  final newPlaylist = Playlist(name: playlistName);
  final playlistBox = await Hive.openBox<Playlist>('playlistbox');

  final key = await playlistBox.add(newPlaylist);
  newPlaylist.id = key;
  playlistsNotifier.value = [...playlistsNotifier.value, newPlaylist];
}

Future<void> gettingPlaylist() async {
  final db = await Hive.openBox<Playlist>('playlistbox');
  playlistsNotifier.value = db.values.toList();
}

//AddSong to playlist
Future<void> addSongToPlaylist(
    String playlistName, PlayListSongModel song) async {
  final openedBox = await Hive.openBox<Playlist>('playlistbox');

  final playlist = openedBox.values.firstWhere(
    (playlist) => playlist.name == playlistName,
    
  );
  playlist.songs.add(song);
}
