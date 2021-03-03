import 'package:dashcast_app/src/widgets/center_scroll.dart';
import 'package:dashcast_app/src/widgets/podcast_column.dart';
import 'package:dashcast_app/src/widgets/podcast_row.dart';
import 'package:dashcast_app/src/widgets/transparent_app_bar.dart';
import 'package:dashcast_server/models.dart';
import 'package:flutter/material.dart';
import 'package:page_router/page_router.dart';

import '../api.dart';

class HomeScreen extends StatefulWidget {
  final DashcastApi api;

  HomeScreen({
    this.api,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading;
  List<Podcast> podcasts;

  void initState() {
    super.initState();
    _loadPodcasts();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
        child: Column(
          children: [
            PodcastRow(
              api: widget.api,
              label: 'Recommended',
              podcasts: podcasts,
              onSelected: (podcast) => _showDetails(context, podcast),
              actionLabel: TextButton(
                onPressed: _handleSeeAll,
                child: Text('See all'),
              ),
              height: 200,
            ),
            Expanded(
              child: PodcastColumn(
                api: widget.api,
                label: "Dash's picks",
                podcasts: podcasts,
                onSelected: (podcast) => _showDetails(context, podcast),
                actionLabel: TextButton(
                  onPressed: _handleSeeAll,
                  child: Text('See all'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _loadPodcasts() async {
    setState(() {
      isLoading = true;
    });
    var podcasts = await widget.api.getAll();
    setState(() {
      this.podcasts = podcasts;
      isLoading = false;
    });
  }

  void _showDetails(BuildContext context, Podcast podcast) {
    PageRouter.of(context).pushNamed('/podcast/${podcast.id}');
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //   return EpisodeListScreen(podcast.id, widget.api);
    // }));
  }

  void _handleSeeAll() {
    PageRouter.of(context).pushNamed('/all');
  }
}
