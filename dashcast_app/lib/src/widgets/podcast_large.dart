import 'package:dashcast_app/src/api.dart';
import 'package:dashcast_app/src/widgets/podcast_image.dart';
import 'package:flutter/material.dart';

import 'package:dashcast_server/models.dart';
import 'package:google_fonts/google_fonts.dart';

class PodcastLarge extends StatelessWidget {
  final DashcastApi api;
  final Podcast podcast;
  final VoidCallback onTap;

  PodcastLarge({
    this.api,
    this.podcast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
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
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
