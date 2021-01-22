import 'package:dashcast_app/src/api.dart';
import 'package:dashcast_server/models.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class PodcastImage extends StatelessWidget {
  final DashcastApi api;
  final Podcast podcast;
  final VoidCallback onTap;
  final bool thumbnail;

  PodcastImage({
    this.api,
    this.podcast,
    this.onTap,
    this.thumbnail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            FadeInImage(
              placeholder: Image.memory(kTransparentImage).image,
              image: NetworkImage(thumbnail
                  ? api.getThumbnailUri(podcast.id)
                  : api.getImageUri(podcast.id)),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.black38,
                  hoverColor: Colors.black12,
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
