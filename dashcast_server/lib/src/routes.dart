import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:pedantic/pedantic.dart';
import 'package:path/path.dart' as path;

import '../models.dart';

part 'routes.g.dart';

class DashcastService {
  final List<PodcastDetails> podcasts;
  final List<Podcast> allPodcasts;
  final Map<int, File> imageFiles;
  final Map<int, File> thumbnails;

  DashcastService(this.podcasts, this.imageFiles, this.thumbnails)
      : allPodcasts =
            podcasts.map((details) => Podcast.fromDetails(details)).toList();

  Router get router => _$DashcastServiceRouter(this);

  @Route.get('/')
  Future<Response> index(Request request) async {
    return Response(200, body: 'DashCast');
  }

  @Route.get('/all')
  Future<Response> all(Request request) async {
    return Response(200,
        body: json.encode(PodcastListResponse(podcasts: allPodcasts)));
  }

  @Route.get('/podcast/<id>')
  Future<Response> getPodcastDetails(Request request, String id) async {
    return Response(200,
        body: json.encode(podcasts.firstWhere((p) => '${p.id}' == id)),
        headers: {'Content-Type': 'application/json'});
  }

  @Route.get('/podcast/<id>/image')
  Future<Response> getPodcastImage(Request request, String id) async {
    var file = imageFiles[int.parse(id)];

    return Response(200,
        body: await file.readAsBytes(),
        headers: {'Content-Type': _imageContentType(file)});
  }

  @Route.get('/podcast/<id>/thumbnail')
  Future<Response> getPodcastThumbnail(Request request, String id) async {
    var file = thumbnails[int.parse(id)];

    return Response(200,
        body: await file.readAsBytes(),
        headers: {'Content-Type': _imageContentType(file)});
  }

  @Route.get('/podcast/<id>/episode/<episodeId>/audio')
  Future<Response> getPodcastAudio(
      Request serverRequest, String id, String episodeId) async {
    var proxyName = 'dashcast';
    var sourceUri = Uri.parse(podcasts
        .firstWhere((p) => p.id == int.parse(id))
        .episodes
        .firstWhere((e) => e.id == int.parse(episodeId))
        .audioUrl);
    var requestUrl = sourceUri.resolve(serverRequest.url.toString());

    var client = http.Client();
    var clientRequest = http.StreamedRequest('GET', sourceUri);
    clientRequest.headers.addAll(serverRequest.headers);
    clientRequest.headers['Host'] = sourceUri.authority;
    _addHeader(clientRequest.headers, 'via',
        '${serverRequest.protocolVersion} $proxyName');

    unawaited(serverRequest
        .read()
        .forEach(clientRequest.sink.add)
        .catchError(clientRequest.sink.addError)
        .whenComplete(clientRequest.sink.close));

    var clientResponse = await client.send(clientRequest);
    _addHeader(clientResponse.headers, 'via', '1.1 $proxyName');
    clientResponse.headers.remove('transfer-encoding');
    // If the original response was gzipped, it will be decoded by [client]
    // and we'll have no way of knowing its actual content-length.
    if (clientResponse.headers['content-encoding'] == 'gzip') {
      clientResponse.headers.remove('content-encoding');
      clientResponse.headers.remove('content-length');

      // Add a Warning header. See
      // http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.5.2
      _addHeader(
          clientResponse.headers, 'warning', '214 $proxyName "GZIP decoded"');
    }

    // Make sure the Location header is pointing to the proxy server rather
    // than the destination server, if possible.
    if (clientResponse.isRedirect &&
        clientResponse.headers.containsKey('location')) {
      var location =
          requestUrl.resolve(clientResponse.headers['location']).toString();
      if (path.url.isWithin(sourceUri.toString(), location)) {
        clientResponse.headers['location'] =
            '/' + path.url.relative(location, from: sourceUri.toString());
      } else {
        clientResponse.headers['location'] = location;
      }
    }

    return Response(200,
        body: clientResponse.stream,
        headers: clientResponse.headers);
  }
}

void _addHeader(Map<String, String> headers, String name, String value) {
  if (headers.containsKey(name)) {
    headers[name] += ', $value';
  } else {
    headers[name] = value;
  }
}

String _imageContentType(File file) {
  var extension = path.extension(file.path);
  if (extension == '.jpg' || extension == '.jpeg') {
    return 'image/jpeg';
  } else {
    return 'image/png';
  }
}
