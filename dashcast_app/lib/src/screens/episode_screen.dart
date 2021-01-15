import 'package:dashcast_app/src/api.dart';
import 'package:dashcast_app/src/widgets/center_scroll.dart';
import 'package:flutter/material.dart';

import 'package:dashcast_server/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

import '../widgets/podcast_image.dart';
import '../widgets/transparent_app_bar.dart';
import '../widgets/audio_player.dart';

class EpisodeScreen extends StatelessWidget {
  final DashcastApi api;
  final Podcast podcast;
  final Episode episode;

  EpisodeScreen({
    this.api,
    this.podcast,
    this.episode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(),
      body: SingleChildScrollView(
        child: CenterScrollable(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PodcastImage(api: api, podcast: podcast),
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
                  uri: Uri.parse(podcast.link),
                  builder: (context, followLink) {
                    return TextButton(
                      onPressed: followLink,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${podcast.title}',
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
                    audioUrl: api.getAudioUrl(podcast.id, episode.id)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
