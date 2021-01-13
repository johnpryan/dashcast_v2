import 'package:dashcast_app/src/screens/podcast_list.dart';
import 'package:dashcast_app/src/widgets/podcast_row.dart';
import 'package:dashcast_app/src/widgets/transparent_app_bar.dart';
import 'package:dashcast_server/models.dart';
import 'package:flutter/material.dart';

import '../api.dart';
import 'episode_list.dart';

class HomeScreen extends StatefulWidget {
  final DashcastApi api;

  HomeScreen({
    this.api,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: Column(
        children: [
          PodcastRow(
            api: widget.api,
            podcasts: podcasts,
            onSelected: (podcast) => _showDetails(context, podcast),
            actionLabel: TextButton(
              onPressed: _handleSeeAll,
              child: Text('See all'),
            ),
          ),
        ],
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
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EpisodeListScreen(podcast.id, widget.api);
    }));
  }

  void _handleSeeAll() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PodcastListScreen(widget.api);
    }));
  }
}
