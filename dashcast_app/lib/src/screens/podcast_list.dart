import 'package:dashcast_app/src/screens/episode_list.dart';
import 'package:dashcast_app/src/widgets/transparent_app_bar.dart';
import 'package:dashcast_server/models.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../api.dart';

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
      body: ListView.builder(
        itemBuilder: (context, idx) {
          var podcast = podcasts[idx];
          return ListTile(
            leading: FadeInImage(
              placeholder: Image.memory(kTransparentImage).image,
              image: NetworkImage(widget.api.getImageUri(podcast.id)),
            ),
            title: Text(podcast.title),
            onTap: () {
              _showDetails(context, podcast);
            },
          );
        },
        itemCount: podcasts.length,
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
}
