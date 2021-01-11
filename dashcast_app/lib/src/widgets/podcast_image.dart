import 'package:dashcast_app/src/api.dart';
import 'package:dashcast_server/models.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class PodcastImage extends StatelessWidget {
  final DashcastApi api;
  final Podcast podcast;

  PodcastImage({
    this.api,
    this.podcast,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: Image.memory(kTransparentImage).image,
      image: NetworkImage(api.getImageUri(podcast.id)),
    );
  }
}
