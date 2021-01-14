import 'dart:async';

import 'dart:math' as math;
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
  bool isLoading = false;

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DurationLabel(duration: playbackPosition),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    LinearProgressIndicator(value: isLoading ? null : progress),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DurationLabel(duration: playbackDuration),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...[
              IconButton(
                icon: Icon(Icons.replay_10),
                onPressed: !isLoading && playbackPosition != null
                    ? () => _replay10()
                    : null,
              ),
              IconButton(
                icon: playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                onPressed: !isLoading ? () => _playPause() : null,
              ),
              IconButton(
                icon: Icon(Icons.forward_10),
                onPressed: !isLoading && playbackPosition != null
                    ? () => _forward10()
                    : null,
              )
            ].map(
              (child) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: child,
              ),
            )
          ],
        ),
      ],
    );
  }

  void dispose() {
    if (sound.thePlayer.isOpen()) {
      sound.thePlayer.closeAudioSession();
    }
    playerSubscription?.cancel();
    super.dispose();
  }

  Future _playPause() async {
    if (!playing && !sound.thePlayer.isOpen()) {
      setState(() {
        isLoading = true;
      });
      await sound.thePlayer.openAudioSession();
      await sound.thePlayer.setSubscriptionDuration(Duration(milliseconds: 10));
      await sound.thePlayer.startPlayer(fromURI: widget.audioUrl);
      setState(() {
        isLoading = false;
      });
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

  void _replay10() {
    var positionMinus10 = playbackPosition - Duration(seconds: 10);
    var newLocationSeconds = math.max(positionMinus10.inSeconds, 0);
    _seek(Duration(seconds: newLocationSeconds));
  }

  void _forward10() {
    var positionPlus10 = playbackPosition + Duration(seconds: 10);
    var newLocationSeconds =
        math.min(positionPlus10.inSeconds, playbackDuration.inSeconds);
    _seek(Duration(seconds: newLocationSeconds));
  }

  Future _seek(Duration newLocation) async {
    await sound.thePlayer.seekToPlayer(newLocation);

    setState(() {
      playbackPosition = newLocation;
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
