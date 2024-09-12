
import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenAbout extends StatelessWidget {
  ScreenAbout({super.key});
  final Uri url = Uri.parse(
      "https://sinancholakkal.github.io/Personal-web-site/contact.html");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        iconTheme:const IconThemeData(color: white, size: 30),
        //backgroundColor: const Color.fromARGB(255, 179, 17, 155),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          //gradient: AppColors.background,
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: settingsListTile(
          icon: Icons.feedback,
          title: "Feadback",
          subtitle: "Feadbacks Appreciated!",
          onTap: () {
            urlLaucher(context);
          },
        ),
      ),
    );
  }

  Future<void> urlLaucher(BuildContext context) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot open this link")),
      );
    }
  }
}
