import 'package:dashcast_app/src/api.dart';
import 'package:dashcast_app/src/widgets/podcast_large.dart';
import 'package:flutter/material.dart';

import 'package:dashcast_server/models.dart';
import 'package:google_fonts/google_fonts.dart';

class PodcastRow extends StatelessWidget {
  final DashcastApi api;
  final String label;
  List<Podcast> podcasts;
  final ValueChanged onSelected;
  final Widget actionLabel;

  PodcastRow({
    this.api,
    this.label,
    this.podcasts,
    this.onSelected,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended',
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
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: 200),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, idx) {
              return PodcastLarge(
                podcast: podcasts[idx],
                api: api,
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
