import 'package:dashcast_app/src/api.dart';
import 'package:dashcast_app/src/widgets/podcast_large.dart';
import 'package:flutter/material.dart';

import 'package:dashcast_server/models.dart';

import 'section_header.dart';

class PodcastRow extends StatelessWidget {
  final DashcastApi api;
  final String label;
  final List<Podcast> podcasts;
  final ValueChanged onSelected;
  final Widget actionLabel;
  final double height;

  PodcastRow({
    this.api,
    this.label,
    this.podcasts,
    this.onSelected,
    this.actionLabel,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(
          label: label,
          actionLabel: actionLabel,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: height),
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
