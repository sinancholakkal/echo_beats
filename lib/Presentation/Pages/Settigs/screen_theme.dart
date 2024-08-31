import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';

class ScreenTheme extends StatelessWidget {
  ScreenTheme({super.key});
  final ValueNotifier<bool> togglevalue = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Theme",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        //backgroundColor: const Color.fromARGB(255, 179, 17, 155),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: white, size: 30),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          //gradient: AppColors.background,
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: ListTile(
          title: Text(
            "Dark Mode",
            style: TextStyle(color: white),
          ),
          trailing: ValueListenableBuilder<bool>(
            valueListenable: togglevalue,
            builder: (BuildContext context, result, Widget? child) {
              return Switch(
                  value: result,
                  onChanged: (val) {
                    togglevalue.value = val;
                  });
            },
          ),
        ),
      ),
    );
  }
}
