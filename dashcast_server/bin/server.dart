import 'dart:io';

import 'package:args/args.dart';
import 'package:dashcast_server/models.dart';
import 'package:dashcast_server/src/routes.dart';
import 'package:dashcast_server/src/util/xml.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:image/image.dart';

const _hostname = 'localhost';

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
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
    // The Daily
    'http://rss.art19.com/the-daily',
    // Sound Opinions
    'https://feeds.simplecast.com/Nn6fjnB0',
    // Stuff You Missed in History Class
    'https://feeds.megaphone.fm/stuffyoumissedinhistoryclass',
    // Stuff You Should Know
    'https://feeds.megaphone.fm/stuffyoushouldknow',
    // The Moth
    'http://feeds.feedburner.com/themothpodcast',
    // Fresh Air
    'https://feeds.npr.org/381444908/podcast.xml',
    // Planet Money
    'https://feeds.npr.org/510289/podcast.xml',
  ];

  print('loading podcasts...');
  var podcasts = await _loadPodcasts(podcastUrls);

  print('downloading images...');
  var imageFiles = await _downloadImages(podcasts);

  print('creating thumbnails...');
  var thumbnails = await _createThumbnails(imageFiles);

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(DashcastService(podcasts, imageFiles, thumbnails).router);

  var server = await io.serve(handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}

Future<List<PodcastDetails>> _loadPodcasts(List<String> podcastUrls) async {
  var podcasts = <PodcastDetails>[];
  var pendingRequests = <Future>[];
  var id = 0;
  for (var podcastUrl in podcastUrls) {
    pendingRequests.add(Future(() async {
      podcasts.add(await _loadPodcast(podcastUrl, id++));
    }));
  }

  await Future.wait(pendingRequests);
  return podcasts;
}

Future<PodcastDetails> _loadPodcast(String podcastUrl, int id) async {
  print('Fetching RSS: $podcastUrl');
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
      id: id,
      title: podcastXml.title,
      rssFeedUrl: podcastUrl,
      imageUrl: podcastXml.imageUrl,
      episodes: episodes);
  return podcast;
}

Future<Map<int, File>> _downloadImages(List<Podcast> podcasts) async {
  var dir = Directory(path.join(Directory.systemTemp.path, 'dashcast'));
  await dir.create();

  var fileMap = <int, File>{};
  var pending = <Future>[];
  for (var podcast in podcasts) {
    pending
        .add(_downloadImage(dir, podcast).then((f) => fileMap[podcast.id] = f));
  }
  await Future.wait(pending);
  return fileMap;
}

Future<File> _downloadImage(Directory dir, Podcast podcast) async {
  var extension = path.extension(Uri.parse(podcast.imageUrl).path);
  var image = await http.get(podcast.imageUrl);
  var file = File(path.join(dir.path, '${podcast.id}${extension}'));
  await file.writeAsBytes(image.bodyBytes);
  return file;
}

Future<Map<int, File>> _createThumbnails(Map<int, File> images) async {
  var dir =
      Directory(path.join(Directory.systemTemp.path, 'dashcast', 'thumbnails'));
  await dir.create();
  var thumbnails = <int, File>{};
  for (var id in images.keys) {
    var sourceFile = images[id];
    thumbnails[id] = await _createThumbnail(id, sourceFile, dir);
  }
  return thumbnails;
}

Future<File> _createThumbnail(int id, File source, Directory directory) async {
  var bytes = await source.readAsBytes();

  Image image;
  if (_isJpeg(source)) {
    image = readJpg(bytes);
  } else if (_isPng(source)) {
    image = readPng(bytes);
  } else {
    throw ('Unknown image type: ${source.path}');
  }

  var thumbnail = copyResize(image, width: 200);
  var thumbnailFile =
      File(path.join(directory.path, '${id}_thumb${_extension(source)}'));
  var thumbnailBytes =
      _isJpeg(source) ? writeJpg(thumbnail) : writePng(thumbnail);
  await thumbnailFile.writeAsBytes(thumbnailBytes);
  return thumbnailFile;
}

String _extension(File file) => path.extension(file.path);

bool _isJpeg(File file) =>
    _extension(file) == '.jpg' || _extension(file) == '.jpeg';

bool _isPng(File file) => _extension(file) == '.png';
