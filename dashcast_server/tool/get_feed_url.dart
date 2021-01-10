import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Fetches the Apple Podcasts RSS feed url from the Apple Podcasts ID. The id
/// should be the Apple Podcasts URL or ID.
/// for example:
/// "id1444919174"
/// "https://podcasts.apple.com/us/podcast/its-all-widgets-flutter-podcast/id1444919174"
Future main(List<String> parameters) async {
  if (parameters.length != 1) {
    print('usage: dart get_feed_url.dart <Apple Podcasts id or URL>');
    exit(1);
  }
  var param = parameters[0];
  var regex = RegExp(r'id(\d+)');
  var id = regex.firstMatch(param).group(1);
  var queryParameters = {'id': id, 'entity': 'podcast'};
  var uri = Uri.parse('https://itunes.apple.com/lookup')
      .replace(queryParameters: queryParameters);
  var response = await http.get(uri);
  var jsonMap = json.decode(response.body);
  var results = jsonMap['results'];
  for (var result in results) {
    print(result['feedUrl']);
  }
}
