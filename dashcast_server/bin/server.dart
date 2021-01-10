import 'dart:io';

import 'package:args/args.dart';
import 'package:dashcast_server/models.dart';
import 'package:dashcast_server/src/routes.dart';
import 'package:dashcast_server/src/util/xml.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

const _hostname = 'localhost';

void main(List<String> args) async {
  var parser = ArgParser()
    ..addOption('port', abbr: 'p');
  var result = parser.parse(args);

  // Use the PORT environment variable if it's defined.
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '8080';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    exitCode = 64;
    return;
  }

  var podcastUrls = [
    'http://rss.art19.com/the-daily',
  ];

  print('loading podcasts...');
  var podcasts = await _loadPodcasts(podcastUrls);

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(DashcastService(podcasts).router);

  var server = await io.serve(handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}

Future<List<PodcastDetails>> _loadPodcasts(List<String> podcastUrls) async {
  var podcasts = <PodcastDetails>[];
  var pendingRequests = <Future>[];
  for (var podcastUrl in podcastUrls) {
    pendingRequests.add(Future(() async {
      podcasts.add(await _loadPodcast(podcastUrl));
    }));
  }

  await Future.wait(pendingRequests);
  return podcasts;
}

Future<PodcastDetails> _loadPodcast(String podcastUrl) async {
  var httpResponse = await http.get(podcastUrl);
  var podcastXml = PodcastXml(httpResponse.body);
  var episodes = <Episode>[];
  for (var i = 0; i < podcastXml.episodes.length; i++) {
    var episodeXml = podcastXml.episodes[i];
    var e =
    Episode(id: i, title: episodeXml.title, audioUrl: episodeXml.audioUrl);
    episodes.add(e);
  }

  var podcast = PodcastDetails(
      id: 0,
      title: podcastXml.title,
      rssFeedUrl: podcastUrl,
      imageUrl: podcastXml.imageUrl,
      episodes: episodes);
  return podcast;
}
