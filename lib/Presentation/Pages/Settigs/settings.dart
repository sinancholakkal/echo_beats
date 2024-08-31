import 'package:echo_beats_music/Presentation/Pages/Settigs/screen_about.dart';
import 'package:echo_beats_music/Presentation/Pages/Settigs/screen_theme.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //backgroundColor: const Color.fromARGB(255, 179, 17, 155),
        iconTheme: const IconThemeData(color: white, size: 30),
        title: const Text(
          "Settings",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          //gradient: AppColors.background,
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: SafeArea(
          child: Column(
            children: [
              //theme----------------------------
              settingsListTile(
                  icon: Icons.color_lens,
                  title: "Theme",
                  subtitle: "Dark Mode",
                  onTap: () {
                    Get.to(() => ScreenTheme(),
                        transition: Transition.cupertino);
                  }),
              //About---------------------
              settingsListTile(
                  icon: Icons.info,
                  title: "About",
                  subtitle: "Contact Us",
                  onTap: () {
                    Get.to(() => ScreenAbout(),
                        transition: Transition.cupertino);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
