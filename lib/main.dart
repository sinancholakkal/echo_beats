
import 'package:echo_beats_music/Presentation/Pages/screen_splash.dart';
import 'package:echo_beats_music/Untils/Theme/them.dart';
import 'package:echo_beats_music/database/functions_hive/theme/db_function_theme.dart';
import 'package:echo_beats_music/database/models/allsongs/all_song_model.dart';
import 'package:echo_beats_music/database/models/favourite/favourite_class_model.dart';
import 'package:echo_beats_music/database/models/playList/playlist_model.dart';
import 'package:echo_beats_music/database/models/recentlyPlayed/recently_played_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';


Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  
  await Hive.initFlutter();
  await getTheme();
  if(!Hive.isAdapterRegistered(SongModelClassAdapter().typeId)){
    Hive.registerAdapter(SongModelClassAdapter());
  }
  if(!Hive.isAdapterRegistered(PlayListSongModelAdapter().typeId)){
    Hive.registerAdapter(PlayListSongModelAdapter());
  }
  if(!Hive.isAdapterRegistered(PlaylistAdapter().typeId)){
    Hive.registerAdapter(PlaylistAdapter());
  }
  if(!Hive.isAdapterRegistered(RecentlyPlayedModelAdapter().typeId)){
    Hive.registerAdapter(RecentlyPlayedModelAdapter());
  }
  if(!Hive.isAdapterRegistered(AllSongModelAdapter().typeId)){
    Hive.registerAdapter(AllSongModelAdapter());
  }
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //static ValueNotifier<ThemeMode> themeNotifier =ValueNotifier(ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder(
      valueListenable: themeNoti,
      builder: (BuildContext context, value, Widget? child) { 
        return GetMaterialApp( 
        themeMode:value=="dark" ?ThemeMode.dark : value =="light" ?ThemeMode.light: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        theme: lightMode.copyWith(
           textTheme: GoogleFonts.poppinsTextTheme(),
           
        ),
        darkTheme: darkMode,
        home: const ScreenSplash(),
        initialRoute: 'splash',
        
      );
       },
    
    );
  }
}