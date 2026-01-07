import 'package:flutter/material.dart';

class Countdown extends AnimatedWidget {
  final Animation<int>? animation;

  Countdown({
    super.key,
    this.animation,
  }) : super(listenable: animation!);

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation!.value);

    String timerText =
        '${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')} seconds left';

    return Text(
      timerText,
      style: const TextStyle(fontSize: 20, color: Colors.black),
    );
  }
}
