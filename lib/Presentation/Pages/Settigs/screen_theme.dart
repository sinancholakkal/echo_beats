import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/database/functions_hive/theme/db_function_theme.dart';
import 'package:flutter/material.dart';

class ScreenTheme extends StatefulWidget {
  const ScreenTheme({super.key});

  @override
  State<ScreenTheme> createState() => _ScreenThemeState();
}

class _ScreenThemeState extends State<ScreenTheme> {
  late ValueNotifier<bool> togglevalue;

  @override
  void initState() {
    super.initState();
    // Initialize togglevalue based on the current theme
    togglevalue = ValueNotifier<bool>(themeNoti.value == 'light');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Theme",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: white, size: 30),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: ListTile(
          title: const Text(
            "Pinky Mode",
            style: TextStyle(color: white),
          ),
          trailing: ValueListenableBuilder(
            valueListenable: togglevalue,
            builder: (BuildContext context, value, Widget? child) {
              return Switch(
                value: value,
                onChanged: (val) {
                  // Update the theme and the togglevalue
                  if (val) {
                    addThem('light');
                  } else {
                    addThem('dark');
                  }
                  togglevalue.value = val;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
