
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:on_audio_query/on_audio_query.dart';

// Search fieald------------------------

Widget searchField(
    {required Color color,
    required String hint,
    IconData? iconData,
    IconButton? iconButton,
    required bool showCursor,
    TextEditingController? txtControl,
    required void Function() onTap,
    required TextInputType type}) {
  return TextFormField(
    autofocus: false,
    controller: txtControl,
    //keyboardType: ,
    style: const TextStyle(color: Colors.black),
    onTap: onTap,
    showCursor: showCursor,
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

ValueNotifier<String> musicNameNotifier = ValueNotifier("");
ValueNotifier<bool> isPlaying = ValueNotifier<bool>(true);
//music card--------
Widget musicCard({
  //AssetImage? image,
  required String musicName,
  required String artistName,
  required void Function() operation,
  IconButton? IconButton,
  PopupMenuButton? PopupMenuButton,
  required BuildContext context,
  required QueryArtworkWidget queryArtWidget,
}) {
  return Card(
    //shadowColor: Colors.black,
    elevation: 4,
    color: Theme.of(context).colorScheme.secondary,
    child: SizedBox(
      height: 90,
      child: Center(
        child: ValueListenableBuilder(
          valueListenable: musicNameNotifier,
          builder: (BuildContext context, value, Widget? child) {
            return ValueListenableBuilder(
              valueListenable: isPlaying,
              builder: (BuildContext context, isPlayValue, Widget? child) {
                return ListTile(
                  onTap: operation,
                  titleTextStyle: TextStyle(
                      color: value == musicName ? Colors.blue : white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  subtitleTextStyle: const TextStyle(
                      color: white, fontWeight: FontWeight.bold),
                  leading: queryArtWidget,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MarqueeText(
                      speed: 14,
                      text: TextSpan(
                        text: musicName,
                        // style: const TextStyle(
                        //   fontSize: 16,
                        //   fontWeight: FontWeight.bold,
                        //   color: white,
                        // ),
                      ),
                    ),
                  ),
                  subtitle: Text(artistName),
                  //trailing: IconButton ?? PopupMenuButton,
                  trailing: value == musicName && isPlayValue == true
                      ? Lottie.asset(
                          "asset/nowplaying/Animation - 1726483606689.json",
                        )
                      : IconButton ?? PopupMenuButton,
                );
              },
            );
          },
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

//Alert dialog for delete
void showDelete({
  required BuildContext context,
  required String title,
  required String content,
  int? key,
  String? playlistName,
  required void Function() delete,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(title,style: const TextStyle(color: Colors.white),),
        content: Text(content,style: const TextStyle(color: Colors.white),),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: white),
              )),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(AppColors.appNameColor)),
            onPressed: delete,
            child: const Text("Delete"),
          )
        ],
      );
    },
  );
}

//toast message
// ignore: prefer_function_declarations_over_variables
final showAddedToast = ({required String msg}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: Colors.grey[500],
  );
};

Widget alertWithtext(
    {required void Function() ok,
    required Widget content,
    required BuildContext context}) {
  return AlertDialog(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    title: const Text("Name"),
    content: content,
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          "Cancel",
          style: TextStyle(color: white),
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.appNameColor)),
        onPressed: ok,
        child: const Text("Ok"),
      )
    ],
  );
}

Future<int?> showSleepModeDialog(BuildContext context)async {
  int? sleepMinit;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text("Select Sleep Duration"),
        content: Container(
            width: double.maxFinite,
            height: 200,
            child: ListWheelScrollView.useDelegate(
              physics: FixedExtentScrollPhysics(),
              itemExtent: 50,
              childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    return InkWell(
                      child: minute(minit: index + 1),
                      onTap: (){
                        sleepMinit =index+1;
                        print("${index+1} =============================================");
                        Get.back();
                      },
                    );
                  },
                  childCount: 59),
            )),
        actions: [
          TextButton(
            child: const Text(
              "Close",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  return sleepMinit;
}


Widget minute({required int minit}) {
  return Container(
    color: AppColors.appNameColor,
    child: Center(
      child: Text(minit.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
    ),
  );
}
