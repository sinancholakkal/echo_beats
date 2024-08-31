import 'package:echo_beats_music/Presentation/Widgets/widgets.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ScreenSearch extends StatelessWidget {
  const ScreenSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          //gradient: AppColors.background,
           color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                sizeBox(h: 20),
                Row(
                  children: [
                    //Search field
                    Expanded(
                      child: searchField(
                          color: white,
                          hint: "Songs",
                          showCursor: false,
                          onTap: () {},
                          type: TextInputType.text,
                          iconButton: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(Icons.arrow_back,color: Colors.black,))),
                    )
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
