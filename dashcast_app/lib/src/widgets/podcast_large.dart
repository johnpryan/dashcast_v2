import 'package:dashcast_app/src/api.dart';
import 'package:dashcast_app/src/widgets/podcast_image.dart';
import 'package:flutter/material.dart';

import 'package:dashcast_server/models.dart';
import 'package:google_fonts/google_fonts.dart';

class PodcastLarge extends StatelessWidget {
  final DashcastApi api;
  final Podcast podcast;
  final VoidCallback onTap;
  final BoxConstraints constraints;

  PodcastLarge({
    this.api,
    this.podcast,
    this.onTap,
    this.constraints = const BoxConstraints.tightFor(width: 120),
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: PodcastImage(
              api: api,
              podcast: podcast,
              onTap: onTap,
              thumbnail: true,
            ),
          ),
          Text(
            podcast.title,
            style: GoogleFonts.openSans().copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
