import 'package:dashcast_app/src/screens/episode_list.dart';
import 'package:dashcast_app/src/screens/podcast_list.dart';
import 'package:flutter/material.dart';

import 'package:page_router/page_router.dart';

import 'api.dart';
import 'screens/episode_screen.dart';
import 'screens/home_screen.dart';
import 'widgets/fade_transition_page.dart';

// final serverUri = Uri.parse('http://localhost:8080');
final serverUri = Uri.parse('https://dashcast.net/');

class DashcastApp extends StatefulWidget {
  @override
  _DashcastAppState createState() => _DashcastAppState();
}

class _DashcastAppState extends State<DashcastApp> {
  DashcastApi api;

  PageRouterData routerData;

  void initState() {
    super.initState();

    api = DashcastApi(serverUri);
    routerData = PageRouterData({
      '/': (context, params) => FadeTransitionPage(
            key: ValueKey('/'),
            child: HomeScreen(api: api),
          ),
      '/all': (context, params) => FadeTransitionPage(
            key: ValueKey('/users/:id'),
            child: PodcastListScreen(api),
          ),
      '/podcast/:id': (context, params) => FadeTransitionPage(
            key: ValueKey('/podcast/:id'),
            child: EpisodeListScreen(
              int.tryParse(params[':id']),
              api,
            ),
          ),
      '/podcast/:id/episode/:episodeId': (context, params) =>
          FadeTransitionPage(
            key: ValueKey('/podcast/:id/episode/:episodeId'),
            child: EpisodeScreen(
              podcastId: int.tryParse(params[':id']),
              episodeId: int.tryParse(params[':episodeId']),
              api: api,
            ),
          ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageRouter(
      data: routerData,
      child: MaterialApp.router(
        title: 'DashCast',
        routerDelegate: routerData.routerDelegate,
        routeInformationParser: routerData.informationParser,
      ),
    );
  }
}
