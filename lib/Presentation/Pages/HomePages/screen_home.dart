import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:echo_beats_music/Presentation/Pages/HomePages/Tabs/screen_account.dart';
import 'package:echo_beats_music/Presentation/Pages/HomePages/Tabs/screen_home_tab.dart';
import 'package:echo_beats_music/Presentation/Pages/HomePages/Tabs/screen_music_tab.dart';
import 'package:echo_beats_music/Presentation/Pages/HomePages/Tabs/screen_playlist_tab.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/database/functions/recentlyPlayed/db_function_recently_played.dart';
import 'package:flutter/material.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';

class ScreenHomes extends StatefulWidget {
  const ScreenHomes({super.key});

  @override
  _ScreenHomesState createState() => _ScreenHomesState();
}

class _ScreenHomesState extends State<ScreenHomes> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  // List of widgets for each tab
  final List<Widget> _pages = [
    HomeTab(),
    MusicTab(),
    PlaylistTab(),
    ScreenAccount()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
       // color: cardColor,
        color: Theme.of(context).primaryColor,
        backgroundColor: AppColors.appNameColor,
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: white,
          ),
          Icon(
            Icons.music_note,
            size: 30,
            color: white,
          ),
          Icon(
            Icons.playlist_add,
            size: 30,
            color: white,
          ),
          Icon(
            Icons.account_circle_rounded,
            size: 30,
            color: white,
          )
        ],
        onTap: (index) {
          _currentIndex.value = index;
        },
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          //gradient: AppColors.background,
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (BuildContext context, value, Widget? child) {
            return IndexedStack(
              index: value,
              children: _pages, // Display the selected page
            );
          },
        ),
      ),
    );
  }
}
