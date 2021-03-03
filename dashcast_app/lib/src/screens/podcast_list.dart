import 'package:dashcast_app/src/widgets/center_scroll.dart';
import 'package:dashcast_app/src/widgets/podcast_list_tile.dart';
import 'package:dashcast_server/models.dart';
import 'package:flutter/material.dart';
import 'package:page_router/page_router.dart';

import '../api.dart';
import '../widgets/transparent_app_bar.dart';

class PodcastListScreen extends StatefulWidget {
  final DashcastApi api;

  PodcastListScreen(this.api);

  @override
  _PodcastListScreenState createState() => _PodcastListScreenState();
}

class _PodcastListScreenState extends State<PodcastListScreen> {
  bool loading;
  List<Podcast> podcasts;

  void initState() {
    super.initState();
    _loadPodcasts();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: TransparentAppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: TransparentAppBar(),
      body: CenterScrollable(
        child: ListView.builder(
          itemBuilder: (context, idx) {
            var podcast = podcasts[idx];
            return PodcastListTile(
              api: widget.api,
              podcast: podcast,
              onTap: () {
                _showDetails(context, podcast);
              },
            );
          },
          itemCount: podcasts.length,
        ),
      ),
    );
  }

  Future _loadPodcasts() async {
    setState(() {
      loading = true;
    });
    var podcasts = await widget.api.getAll();
    setState(() {
      this.podcasts = podcasts;
      loading = false;
    });
  }

  void _showDetails(BuildContext context, Podcast podcast) {
    PageRouter.of(context).pushNamed('/podcast/${podcast.id}');
  }
}
