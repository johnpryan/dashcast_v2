import 'package:dashcast_app/src/screens/episode_list.dart';
import 'package:dashcast_app/src/screens/podcast_list.dart';
import 'package:flutter/material.dart';

import 'package:page_router/page_router.dart';

import 'api.dart';
import 'screens/episode_screen.dart';
import 'screens/home_screen.dart';

// final serverUri = Uri.parse('http://0.0.0.0:8080');
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
      '/': (context, params) => MaterialPage(
            key: ValueKey('/'),
            child: HomeScreen(api: api),
          ),
      '/all': (context, params) => MaterialPage(
            key: ValueKey('all'),
            child: PodcastListScreen(api),
          ),
      '/podcast/:id': (context, params) => MaterialPage(
            key: ValueKey('/podcast/${params[":id"]}'),
            child: EpisodeListScreen(
              int.tryParse(params[':id']),
              api,
            ),
          ),
      '/podcast/:id/episode/:episodeId': (context, params) => MaterialPage(
            key: ValueKey(
                '/podcast/${params[":id"]}/episode/${params[":episodeId"]}'),
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
