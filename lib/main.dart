
import 'package:echo_beats_music/Presentation/Pages/screen_splash.dart';
import 'package:echo_beats_music/Untils/Theme/them.dart';
import 'package:echo_beats_music/database/models/favourite/favourite_class_model.dart';
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
  if(!Hive.isAdapterRegistered(SongModelClassAdapter().typeId)){
    Hive.registerAdapter(SongModelClassAdapter());
  }
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp( 
      debugShowCheckedModeBanner: false,
      theme: lightMode.copyWith(
         textTheme: GoogleFonts.poppinsTextTheme(),
         
      ),
      darkTheme: darkMode,
      home: const ScreenSplash(),
      initialRoute: 'splash',
      
    );
  }
}