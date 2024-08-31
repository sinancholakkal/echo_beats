import 'package:echo_beats_music/Presentation/Pages/Settigs/settings.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:marquee_text/marquee_text.dart';

class ScreenPlaying extends StatelessWidget {
  String image;
  String songName;
  String artistName;
  ScreenPlaying({
    super.key,
    required this.image,
    required this.artistName,
    required this.songName,
  });

  final ValueNotifier<bool> _isFavorate = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _playPause = ValueNotifier<bool>(true);

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                sizeBox(h: 10),
                Row(
                  children: [
                    //Back Button---------
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 40,
                          color: white,
                        )),
                    const Spacer(),
                    //Share Button--------------
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share,
                          size: 30,
                          color: white,
                        )),
                    sizeBox(w: 12),
                    //Menu Button-----------------
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text("Settigs"),
                            onTap: () {
                              Get.to(() => const ScreenSettings(),
                                  transition: Transition.cupertino);
                            },
                          ),
                        ];
                      },
                      iconColor: white,
                      iconSize: 30,
                    ),
                  ],
                ),
                sizeBox(h: 70),
                //Music Image--------------------
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(image),
                    ),
                  ),
                ),
                sizeBox(h: 40),
                //Music name------------------
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      MarqueeText(
                        speed: 30,
                        text: TextSpan(
                            text: songName,
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: white)),
                      ),
                      MarqueeText(
                        speed: 30,
                        text: TextSpan(
                            text: artistName,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: white)),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Slider(
                      value: 40,
                      min: 0,
                      max: 100,
                      onChanged: (val) {},
                      activeColor: white,
                      inactiveColor: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //music starting time------------
                          Text(
                            "01:26",
                            style: TextStyle(
                              color: white.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //Music ending time---------------
                          Text(
                            "02:10",
                            style: TextStyle(
                              color: white.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                sizeBox(h: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //repeate icon-----------
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.repeat,
                        color: white,
                        size: 30,
                      ),
                    ),
                    //Back song icon-----------------------
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        color: white,
                        size: 50,
                      ),
                    ),
                    //Puse and play--------------
                    ValueListenableBuilder(
                      valueListenable: _playPause,
                      builder: (BuildContext context, value, Widget? child) {
                        return IconButton(
                          onPressed: () {
                            _playPause.value = !_playPause.value;
                          },
                          icon: Icon(
                            value
                                ? Icons.pause_circle_filled
                                : Icons.play_circle,
                            color: white,
                            size: 80,
                          ),
                        );
                      },
                    ),
                    //Next Song------------
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_next,
                        color: white,
                        size: 50,
                      ),
                    ),
                    //Favorate icon---------------
                    ValueListenableBuilder(
                      valueListenable: _isFavorate,
                      builder: (BuildContext context, value, Widget? child) {
                        return IconButton(
                          icon: Icon(
                            value ? Icons.favorite_border : Icons.favorite,
                            color: white,
                            size: 30,
                          ),
                          onPressed: () {
                            _isFavorate.value = !_isFavorate.value;
                          },
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
