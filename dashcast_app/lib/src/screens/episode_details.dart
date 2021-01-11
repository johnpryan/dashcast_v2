import 'package:dashcast_app/src/api.dart';
import 'package:flutter/material.dart';

import 'package:dashcast_server/models.dart';

import '../widgets/podcast_image.dart';
import '../widgets/transparent_app_bar.dart';

class EpisodeDetailsScreen extends StatelessWidget {
  final DashcastApi api;
  final Podcast podcast;
  final Episode episode;

  EpisodeDetailsScreen({
    this.api,
    this.podcast,
    this.episode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('${podcast.title} - ${episode.title}'),
            PodcastImage(api: api, podcast: podcast),
          ],
        ),
      ),
    );
  }
}
