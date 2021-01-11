import 'package:dashcast_app/src/widgets/transparent_app_bar.dart';
import 'package:dashcast_server/models.dart';
import 'package:flutter/material.dart';

class EpisodeDetailsScreen extends StatelessWidget {
  final Podcast podcast;
  final Episode episode;

  EpisodeDetailsScreen({
    this.podcast,
    this.episode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(),
      body: Center(child: Text('${podcast.title} - ${episode.title}'),),
    );
  }
}
