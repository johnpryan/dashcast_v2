import 'dart:async';

import 'package:dashcast_app/src/widgets/duration_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioPlayer extends StatefulWidget {
  final String audioUrl;

  AudioPlayer({
    this.audioUrl,
  });

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  FlutterSound sound;
  StreamSubscription<PlaybackDisposition> playerSubscription;
  double progress;
  bool playing = false;
  Duration playbackPosition = Duration.zero;
  Duration playbackDuration = Duration.zero;

  void initState() {
    super.initState();
    progress = 0;
    sound = FlutterSound();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            DurationLabel(duration: playbackPosition),
            Expanded(child: LinearProgressIndicator(value: progress)),
            DurationLabel(duration: playbackDuration),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () => _playPause(),
            )
          ],
        ),
      ],
    );
  }

  void dispose() {
    sound.thePlayer.closeAudioSession();
    playerSubscription.cancel();
    super.dispose();
  }

  Future _playPause() async {
    print('loading ${widget.audioUrl}');
    if (!playing && !sound.thePlayer.isOpen()) {
      await sound.thePlayer.openAudioSession();
      await sound.thePlayer.setSubscriptionDuration(Duration(milliseconds: 10));
      await sound.thePlayer.startPlayer(fromURI: widget.audioUrl);
      playerSubscription = sound.thePlayer.onProgress.listen(_updateProgress);
    } else if (!playing && sound.thePlayer != null) {
      await sound.thePlayer.resumePlayer();
    } else {
      await sound.thePlayer.pausePlayer();
    }
    setState(() {
      playing = !playing;
    });
  }

  void _updateProgress(PlaybackDisposition disposition) {
    setState(() {
      playbackPosition = disposition.position;
      playbackDuration = disposition.duration;
      progress =
          disposition.position.inSeconds / disposition.duration.inSeconds;
    });
  }
}



