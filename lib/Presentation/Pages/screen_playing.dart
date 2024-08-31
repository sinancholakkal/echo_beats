import 'dart:developer';

import 'package:echo_beats_music/Presentation/Pages/Settigs/settings.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenPlaying extends StatefulWidget {
  QueryArtworkWidget? queryArtworkWidget;
  String songName;
  String artistName;
  String? image;
  Uri? urii;
  final AudioPlayer? audioPlayer;
  int? id;
  String? album;
  ScreenPlaying({
    this.audioPlayer,
    super.key,
    this.image,
    required this.artistName,
    required this.songName,
    this.queryArtworkWidget,
    this.urii,
    this.id,
    this.album,
  });

  @override
  State<ScreenPlaying> createState() => _ScreenPlayingState();
}

class _ScreenPlayingState extends State<ScreenPlaying> {
  final ValueNotifier<bool> _isFavorate = ValueNotifier<bool>(true);

  final ValueNotifier<bool> _playPause = ValueNotifier<bool>(true);
  final ValueNotifier<Duration> _duration =
      ValueNotifier<Duration>(const Duration());
  final ValueNotifier<Duration> _position =
      ValueNotifier<Duration>(const Duration());

  playSong() {
    try {
      // Using ConcatenatingAudioSource with MediaItem
      final audioSource = ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
            widget.urii!,
            tag: MediaItem(
              id: "${widget.id}",
              album: widget.album,
              title: widget.songName,
              artUri: Uri.parse('https://example.com/albumart.jpg'),
            ),
          ),
        ],
      );

      widget.audioPlayer!.setAudioSource(audioSource);
      widget.audioPlayer!.play();
    } on Exception {
      log("Error in parsing");
    }

    //For duration--------
    widget.audioPlayer?.durationStream.listen((d) {
      _duration.value = d!;
    });

    //position----
    widget.audioPlayer?.positionStream.listen((p) {
      _position.value = p;
    });
  }

  @override
  void initState() {
    super.initState();
    playSong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            //gradient: AppColors.background,
            color: Theme.of(context).scaffoldBackgroundColor),
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
                    // image: DecorationImage(
                    //   fit: BoxFit.cover,
                    //   image: NetworkImage(image),
                    // ),
                  ),
                  child: widget.queryArtworkWidget,
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
                            text: widget.songName,
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: white)),
                      ),
                      MarqueeText(
                        speed: 30,
                        text: TextSpan(
                            text: widget.artistName,
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
                    ValueListenableBuilder(
                      valueListenable: _position,
                      builder: (BuildContext context, pValue, Widget? child) {
                        return ValueListenableBuilder(
                          valueListenable: _duration,
                          builder:
                              (BuildContext context, dValue, Widget? child) {
                            return Slider(
                              value: pValue.inSeconds.toDouble(),
                              min: const Duration(microseconds: 0)
                                  .inSeconds
                                  .toDouble(),
                              max: dValue.inSeconds.toDouble(),
                              onChanged: (val) {
                                changeToSecond(val.toInt());
                                _position.value =
                                    Duration(seconds: val.toInt());
                              },
                              activeColor: white,
                              inactiveColor: Colors.grey,
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //music starting time------------
                          ValueListenableBuilder(
                            valueListenable: _position,
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return Text(
                                value.toString().split('.')[0],
                                style: TextStyle(
                                  color: white.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          //Music ending time---------------
                          ValueListenableBuilder(
                            valueListenable: _duration,
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return Text(
                                value.toString().split('.')[0],
                                style: TextStyle(
                                  color: white.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
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
                            if (_playPause.value == false) {
                              widget.audioPlayer!.pause();
                            } else {
                              widget.audioPlayer!.play();
                            }
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

  //For rage. change to seconds
  void changeToSecond(int second) {
    Duration duration = Duration(seconds: second);
    widget.audioPlayer!.seek(duration);
  }
}
