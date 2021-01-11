import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;

import '../models.dart';

part 'routes.g.dart';

Map<String, String> _defaultHeaders = {'Access-Control-Allow-Origin': '*'};

class DashcastService {
  final List<PodcastDetails> podcasts;
  final List<Podcast> allPodcasts;
  final Map<int, File> imageFiles;

  DashcastService(this.podcasts, this.imageFiles)
      : allPodcasts =
            podcasts.map((details) => Podcast.fromDetails(details)).toList();

  Router get router => _$DashcastServiceRouter(this);

  @Route.get('/')
  Future<Response> index(Request request) async {
    return Response(200, body: 'DashCast', headers: _defaultHeaders);
  }

  @Route.get('/all')
  Future<Response> all(Request request) async {
    return Response(200,
        body: json.encode(PodcastListResponse(podcasts: allPodcasts)),
        headers: _defaultHeaders);
  }

  @Route.get('/podcast/<id>')
  Future<Response> getPodcastDetails(Request request, String id) async {
    return Response(200,
        body: json.encode(podcasts.firstWhere((p) => '${p.id}' == id)),
        headers: Map.from(_defaultHeaders)
          ..addAll({'Content-Type': 'application/json'}));
  }

  @Route.get('/podcast/<id>/image')
  Future<Response> getPodcastImage(Request request, String id) async {
    var file = imageFiles[int.parse(id)];
    return Response(200,
        body: await file.readAsBytes(),
        headers: Map.from(_defaultHeaders)
          ..addAll({'Content-Type': 'image/jpeg'}));
  }

  @Route.get('/podcast/<id>/episode/<episodeId>/audio')
  Future<Response> getPodcastAudio(
      Request request, String id, String episodeId) async {
    var sourceUrl = podcasts.firstWhere((p) => p.id == int.parse(id))
        .episodes
        .firstWhere((e) => e.id == int.parse(episodeId))
        .audioUrl;
    // var streamedResponse = await http.Client()
    //     .send(http.StreamedRequest('GET', Uri.parse(sourceUrl)));
    // print('got streamedResponse $streamedResponse');
    var response = await http.get(sourceUrl);
    return Response(200,
        body: response.bodyBytes,
        headers: Map.from(_defaultHeaders)
          ..addAll({'Content-Type': 'Content-Type: audio/mpeg'}
            ..addAll(response.headers)));
  }
}
