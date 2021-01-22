import 'dart:convert';
import 'dart:io';

import 'package:dashcast_server/models.dart';
import 'package:http/http.dart' as http;
import 'package:dashcast_server/src/util/xml.dart';

Future main(List<String> parameters) async {
  if (parameters.length != 1) {
    print('usage: dart parse_feed_xml.dart <XML feed URL>');
    exit(1);
  }

  var param = parameters[0];
  var uri = Uri.parse(param);
  var httpResponse = await http.get(uri);
  var podcastXml = PodcastXml(httpResponse.body);
  var episodes = <Episode>[];
  for (var i = 0; i < podcastXml.episodes.length; i++) {
    var episodeXml = podcastXml.episodes[i];
    var e = Episode(
        id: i,
        title: episodeXml.title,
        audioUrl: episodeXml.audioUrl,
        publishDate: episodeXml.publishDate);
    episodes.add(e);
  }

  var podcast = PodcastDetails(
      id: 0,
      title: podcastXml.title,
      rssFeedUrl: uri.toString(),
      imageUrl: podcastXml.imageUrl,
      episodes: episodes);
  for (var episode in episodes) {
    episode.podcast = Podcast.fromDetails(podcast);
  }
  print(json.encode(podcast));
}
