import 'dart:convert';

import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:dashcast_server/models.dart';

class DashcastApi {
  final Uri baseUri;

  DashcastApi(this.baseUri);

  Future<List<Podcast>> getAll() async {
    var response = await _request('all');
    var obj = PodcastListResponse.fromJson(json.decode(response.body));
    return obj.podcasts;
  }

  Future<PodcastDetails> getDetails(int id) async {
    var response = await _request('podcast/$id');
    return PodcastDetails.fromJson(json.decode(response.body));
  }

  Future<http.Response> _request(String path) async {
    var uri = baseUri.replace(path: path);
    var response = await http.get(uri);
    if (response.statusCode != 200) {
      throw DashcastApiException('failed to load data', response);
    }
    return response;
  }

  String getImageUri(int id) {
    return baseUri
        .replace(path: path.join('podcast', '$id', 'image'))
        .toString();
  }

  String getAudioUrl(int id, int episodeId) {
    return baseUri
        .replace(
            path: path.join('podcast', '$id', 'episode', '$episodeId', 'audio'))
        .toString();
  }
}

class DashcastApiException implements Exception {
  final String msg;
  final http.Response response;

  DashcastApiException(this.msg, this.response);

  String toString() {
    return '$msg ${response.statusCode} '
        '${response.request.method} ${response.request.url}';
  }
}
