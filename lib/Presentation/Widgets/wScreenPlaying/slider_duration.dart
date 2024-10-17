import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:flutter/material.dart';

class SliderDuration extends StatelessWidget {
  const SliderDuration({
    super.key,
    required ValueNotifier<Duration> position,
    required ValueNotifier<Duration> duration,
  }) : _position = position, _duration = duration;

  final ValueNotifier<Duration> _position;
  final ValueNotifier<Duration> _duration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          ),
        ],
      ),
    );
  }
}