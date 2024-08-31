import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:on_audio_query/on_audio_query.dart';

// Search fieald------------------------

Widget searchField(
    {required Color color,
    required String hint,
    IconData? iconData,
    IconButton? iconButton,
    required bool showCursor,
    required void Function() onTap,
    required TextInputType type}) {
  return TextFormField(
    keyboardType: type,
    onTap: onTap,
    showCursor: false,
    decoration: InputDecoration(
      fillColor: color,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners
        borderSide: BorderSide.none, // No visible border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(20.0), // Rounded corners when focused
        borderSide: BorderSide.none, // No visible border when focused
      ),
      prefixIcon: iconButton ??
          Icon(
            iconData,
            color: Colors.grey,
          ),
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
    ),
  );
}

//Card fave and shuffle---------------------------
Widget homeCard({
  required List<Color> color,
  required IconData iconData,
  required String text,
  required void Function() onTap,
}) {
  return Expanded(
    child: Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            // const Color.fromARGB(255, 149, 17, 190),
            // const Color.fromARGB(255, 162, 13, 13)
            color[0],
            color[1]
          ],
        ),
      ),
      child: Center(
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            iconData,
            color: Colors.white,
          ),
          title: Text(
            text,
            style: const TextStyle(
              color: white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

//music card--------
Widget musicCard({
  //AssetImage? image,
  required String musicName,
  required String artistName,
  required void Function() operation,
  IconButton? IconButton,
  PopupMenuButton? PopupMenuButton,
  required BuildContext context,
  //required ImageProvider imageProvider,
  required QueryArtworkWidget queryArtWidget,
}) {
  return Card(
    //shadowColor: Colors.black,
    elevation: 4,
    color: Theme.of(context).colorScheme.secondary,
    child: SizedBox(
      height: 90,
      child: Center(
        child: ListTile(
          onTap: operation,
          subtitleTextStyle:
              const TextStyle(color: white, fontWeight: FontWeight.bold),
          leading: queryArtWidget,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: MarqueeText(
              speed: 14,
              text: TextSpan(
                  text: musicName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: white)),
            ),
          ),
          subtitle: Text(artistName),
          trailing: IconButton ?? PopupMenuButton,
        ),
      ),
    ),
  );
}

//Settigs List tile
Widget settingsListTile(
    {required IconData icon,
    required String title,
    required String subtitle,
    required void Function() onTap}) {
  return ListTile(
    titleTextStyle: const TextStyle(
      color: white,
      fontSize: 20,
    ),
    subtitleTextStyle: const TextStyle(color: Colors.white54),
    leading: Icon(
      icon,
      color: white,
      size: 40,
    ),
    title: Text(title),
    subtitle: Text(subtitle),
    onTap: onTap,
  );
}
