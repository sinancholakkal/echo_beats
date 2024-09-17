import 'package:echo_beats_music/Presentation/Pages/Settigs/privacy_policy.dart';
import 'package:echo_beats_music/Presentation/Pages/Settigs/screen_theme.dart';
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            color: Theme.of(context).scaffoldBackgroundColor),
        child: SafeArea(
          child: Column(
            children: [
              //theme----------------------------
              settingsListTile(
                  icon: Icons.color_lens,
                  title: "Theme",
                  subtitle: "Dark Mode",
                  onTap: () {
                    Get.to(() => const ScreenTheme(),
                        transition: Transition.cupertino);
                  }),
              //Feedback---------------------

              settingsListTile(
                icon: Icons.feedback,
                title: "Feedback",
                subtitle: 'sinanzzsinu70@gmail.com',
                onTap: () async {
                  Uri email = Uri(
                    scheme: 'mailto',
                    path: "sinanzzsinu70@gmail.com",
                    query: "subject=[Echo Beats MusicPlayer]-feedback"
                  );

                  // Use launchUrl to open the email app
                  if (await canLaunchUrl(email)) {
                    await launchUrl(email);
                  } else {
                    print('Could not launch email app');
                  }
                },
              ),

              //Privacy and Policy---------------------
              settingsListTile(
                  icon: Icons.info,
                  title: "Privacy Policy",
                  subtitle:'Read our privacy policy here' ,
                  onTap: () {
                    Get.to(() => ScreenPrivacyPolicy(),
                        transition: Transition.cupertino);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
