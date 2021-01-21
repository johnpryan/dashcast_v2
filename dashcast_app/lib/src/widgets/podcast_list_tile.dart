import 'package:dashcast_app/src/api.dart';
import 'package:dashcast_app/src/widgets/podcast_image.dart';
import 'package:flutter/material.dart';

import 'package:dashcast_server/models.dart';

class PodcastListTile extends StatelessWidget {
  final DashcastApi api;
  final Podcast podcast;
  final VoidCallback onTap;

  PodcastListTile({
    this.api,
    this.podcast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PodcastImage(
        api: api,
        podcast: podcast,
        thumbnail: true,
      ),
      title: Text(podcast.title),
      onTap: this.onTap,
    );
  }
}
