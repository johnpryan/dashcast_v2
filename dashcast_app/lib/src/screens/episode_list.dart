import 'package:dashcast_server/models.dart';
import 'package:flutter/material.dart';

import '../api.dart';
import '../widgets/podcast_image.dart';
import '../widgets/transparent_app_bar.dart';
import 'episode_details.dart';

class EpisodeListScreen extends StatefulWidget {
  final int podcastId;
  final DashcastApi api;

  EpisodeListScreen(this.podcastId, this.api);

  @override
  _EpisodeListScreenState createState() => _EpisodeListScreenState();
}

class _EpisodeListScreenState extends State<EpisodeListScreen> {
  bool loading;
  PodcastDetails podcastDetails;

  void initState() {
    super.initState();
    loading = true;
    _loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: TransparentAppBar(),
      body: Scrollbar(
        child: ListView.builder(
          itemBuilder: (context, idx) {
            var episode = podcastDetails.episodes[idx];
            return ListTile(
              leading: PodcastImage(
                api: widget.api,
                podcast: podcastDetails,
                thumbnail: true,
              ),
              title: Text(episode.title),
              onTap: () => _showEpisodeDetails(podcastDetails, episode),
            );
          },
          itemCount: podcastDetails.episodes.length,
        ),
      ),
    );
  }

  Future _loadDetails() async {
    setState(() {
      loading = true;
    });
    var details = await widget.api.getDetails(widget.podcastId);
    setState(() {
      this.podcastDetails = details;
      loading = false;
    });
  }

  void _showEpisodeDetails(Podcast podcast, Episode episode) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return EpisodeDetailsScreen(
            api: widget.api,
            podcast: podcast,
            episode: episode,
          );
        },
      ),
    );
  }
}
