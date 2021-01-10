import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models.dart';

part 'routes.g.dart';

class DashcastService {
  final List<PodcastDetails> podcasts;
  final List<Podcast> allPodcasts;

  DashcastService(this.podcasts)
      : allPodcasts =
            podcasts.map((details) => Podcast.fromDetails(details)).toList();

  Router get router => _$DashcastServiceRouter(this);

  @Route.get('/')
  Future<Response> index(Request request) async {
    return Response(200, body: 'DashCast', headers: {});
  }

  @Route.get('/all')
  Future<Response> all(Request request) async {
    return Response(200, body: json.encode(allPodcasts), headers: {});
  }

  @Route.get('/podcast/<id>')
  Future<Response> getPodcastDetails(Request request, String id) async {
    return Response(200,
        body: json.encode(podcasts.firstWhere((p) => '${p.id}' == id)),
        headers: {'Content-Type': 'application/json'});
  }
}
