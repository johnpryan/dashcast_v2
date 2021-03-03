import 'package:dashcast_app/src/api.dart';
import 'package:dashcast_app/src/widgets/center_scroll.dart';
import 'package:flutter/material.dart';

import 'package:dashcast_server/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

import '../widgets/podcast_image.dart';
import '../widgets/transparent_app_bar.dart';
import '../widgets/audio_player.dart';

class EpisodeScreen extends StatefulWidget {
  final DashcastApi api;
  final int podcastId;
  final int episodeId;

  EpisodeScreen({
    this.api,
    this.podcastId,
    this.episodeId,
  });

  @override
  _EpisodeScreenState createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  bool isLoading;
  Episode episode;

  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: TransparentAppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: TransparentAppBar(),
      body: CenterScrollable(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PodcastImage(api: widget.api, podcast: episode.podcast),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${episode.title}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans().copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // TODO: link widget
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Link(
                  uri: Uri.parse(episode.podcast.link),
                  builder: (context, followLink) {
                    return TextButton(
                      onPressed: followLink,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${episode.podcast.title}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans().copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AudioPlayer(
                    audioUrl: widget.api
                        .getAudioUrl(widget.podcastId, widget.episodeId)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _loadData() async {
    setState(() {
      isLoading = true;
    });

    var episode =
        await widget.api.getEpisode(widget.podcastId, widget.episodeId);

    setState(() {
      this.episode = episode;
      isLoading = false;
    });
  }
}
