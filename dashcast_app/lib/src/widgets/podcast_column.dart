import 'package:dashcast_app/src/api.dart';
import 'package:flutter/material.dart';

import 'package:dashcast_server/models.dart';

import 'podcast_list.dart';
import 'section_header.dart';

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
        SectionHeader(
          label: label,
          actionLabel: actionLabel,
        ),
        Expanded(
          child: PodcastList(
            api: api,
            podcasts: podcasts,
            onSelected: onSelected,
          ),
        ),
      ],
    );
  }
}

