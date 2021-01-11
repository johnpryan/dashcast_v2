import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class DurationLabel extends StatelessWidget {
  final Duration duration;

  DurationLabel({
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    var hours = duration.inHours;
    var minutes = duration.inMinutes.remainder(60);
    var seconds = duration.inSeconds.remainder(60);
    var format = NumberFormat('00');
    var hoursString = format.format(hours);
    var minutesString = format.format(minutes);
    var secondsString = format.format(seconds);
    if (hours == 0) {
      return Text('$minutesString:$secondsString');
    }
    return Text('$hoursString:$minutesString:$secondsString');
  }
}
