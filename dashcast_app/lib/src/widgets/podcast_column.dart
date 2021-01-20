import 'package:dashcast_app/src/api.dart';
import 'package:dashcast_app/src/widgets/podcast_large.dart';
import 'package:dashcast_app/src/widgets/podcast_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:dashcast_server/models.dart';
import 'package:google_fonts/google_fonts.dart';

class PodcastColumn extends StatelessWidget {
  final DashcastApi api;
  final String label;
  final List<Podcast> podcasts;
  final ValueChanged onSelected;
  final Widget actionLabel;

  PodcastColumn({
    this.api,
    this.label,
    this.podcasts,
    this.onSelected,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.openSans().copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (actionLabel != null) actionLabel,
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemBuilder: (context, idx) {
              return PodcastListTile(
                api: api,
                podcast: podcasts[idx],
                onTap: () => onSelected(podcasts[idx]),
              );
            },
            itemCount: podcasts.length,
          ),
        ),
      ],
    );
  }
}
