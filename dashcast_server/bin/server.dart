import 'dart:io';

import 'package:args/args.dart';
import 'package:dashcast_server/models.dart';
import 'package:dashcast_server/src/routes.dart';
import 'package:dashcast_server/src/util/xml.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_helpers/shelf_helpers.dart' show cors;
import 'package:image/image.dart';

const _hostname = '0.0.0.0';

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PATCH, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers':
      'Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers'
};

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);

  print("PORT environment variable = ${Platform.environment['PORT']}");

  // Use the PORT environment variable if it's defined.
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '80';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    exitCode = 64;
    return;
  }

  var podcastUrls = [
    // The Daily
    // 'http://rss.art19.com/the-daily',
    // Sound Opinions
    // 'https://feeds.simplecast.com/Nn6fjnB0',
    // Stuff You Missed in History Class
    // 'https://feeds.megaphone.fm/stuffyoumissedinhistoryclass',
    // Stuff You Should Know
    // 'https://feeds.megaphone.fm/stuffyoushouldknow',
    // Fresh Air
    // 'https://feeds.npr.org/381444908/podcast.xml',
    // Planet Money
    // 'https://feeds.npr.org/510289/podcast.xml',

    // It's All Widgets!
    'https://itsallwidgets.com/podcast/feed',

    // Talks at Google
    'https://talksatgoogle.libsyn.com/rss',

    // Kubernetes Podcast
    'https://kubernetespodcast.com/feeds/audio.xml',

    // The Firebase Podcast
    'https://firebasepodcast.libsyn.com/rss',

    // Google Cloud Platform Podcast
    'https://feeds.feedburner.com/GcpPodcast',

    // The State of the Web
    'https://thestateoftheweb.libsyn.com/rss',

    // The CSS Podcast
    'https://thecsspodcast.libsyn.com/rss',

    // Designer Vs Developer
    'https://anchor.fm/s/ccd1534/podcast/rss',
  ];

  print('loading podcasts...');
  var podcasts = await _loadPodcasts(podcastUrls);
  print('done loading podcasts.');

  print('downloading images...');
  var imageFiles = await _downloadImages(podcasts);
  print('done downloading images.');

  print('creating thumbnails...');
  var thumbnails = await _createThumbnails(imageFiles);
  print('done creating thumbnails.');

  var scriptDir = path.dirname(Platform.script.path);
  var projectDir = path.joinAll(path.split(scriptDir)..removeLast());
  var staticDir = path.join(projectDir, 'lib', 'src', 'static');
  var staticHandler =
      createStaticHandler(staticDir, defaultDocument: 'index.html');

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(cors(headers: _corsHeaders))
      .addHandler(DashcastService(podcasts, imageFiles, thumbnails).router);
  var cascade = shelf.Cascade().add(staticHandler).add(handler);

  print('Starting server at http://${_hostname}:${port}');
  var server = await io.serve(cascade.handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}

Future<List<PodcastDetails>> _loadPodcasts(List<String> podcastUrls) async {
  var podcasts = <PodcastDetails>[];
  var pendingRequests = <Future>[];
  var id = 0;
  for (var podcastUrl in podcastUrls) {
    pendingRequests.add(Future(() async {
      var podcast = await _loadPodcast(podcastUrl, id++);
      if (podcast != null) {
        podcasts.add(podcast);
      }
    }));
  }

  await Future.wait(pendingRequests);
  return podcasts..sort((a,b) => a.id.compareTo(b.id));
}

Future<PodcastDetails> _loadPodcast(String podcastUrl, int id) async {
  print('Fetching RSS: $podcastUrl');
  try {
    var httpResponse = await http.get(podcastUrl);
    var podcastXml = PodcastXml(httpResponse.body);
    var episodes = <Episode>[];
    for (var i = 0; i < podcastXml.episodes.length; i++) {
      var episodeXml = podcastXml.episodes[i];
      var e = Episode(
          id: i, title: episodeXml.title, audioUrl: episodeXml.audioUrl);
      episodes.add(e);
    }

    var podcast = PodcastDetails(
        id: id,
        title: podcastXml.title,
        rssFeedUrl: podcastUrl,
        imageUrl: podcastXml.imageUrl,
        link: podcastXml.link,
        episodes: episodes);

    for (var episode in episodes) {
      episode.podcast = Podcast.fromDetails(podcast);
    }

    return podcast;
  } catch (e) {
    print('error loading podcast: $podcastUrl');
  }
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
