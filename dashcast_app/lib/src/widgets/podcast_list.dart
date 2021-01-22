import 'package:dashcast_server/models.dart';
import 'package:flutter/material.dart';

import '../api.dart';
import 'podcast_list_tile.dart';

class PodcastList extends StatelessWidget {
  final DashcastApi api;
  final List<Podcast> podcasts;
  final ValueChanged onSelected;

  PodcastList({
    this.api,
    this.podcasts,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
