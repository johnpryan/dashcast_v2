import 'package:xml/xml.dart';

import 'date.dart';

/// Extracts podcast data from an RSS feed.
class PodcastXml {
  final XmlDocument _document;

  PodcastXml(String xmlString) : _document = XmlDocument.parse(xmlString);

  /// The podcast title
  String get title => _channel.findElements('title').first.text;

  String get imageUrl =>
      _channel.findElements('image').first.findElements('url').first.text;

  String get link => _channel.findElements('link').first.text;

  List<EpisodeXml> get episodes {
    return _channel.findElements('item').map((n) => EpisodeXml(n)).toList();
  }

  XmlNode get _channel => _document.rootElement.findElements('channel').first;
}

/// Extracts episode data from an RSS feed's "channel" node.
class EpisodeXml {
  final XmlNode _node;

  EpisodeXml(XmlNode node) : _node = node;

  String get title => _node.findElements('title').first.text;

  DateTime get publishDate => parseDate(publishDateString);

  String get publishDateString => _node.findElements('pubDate').first.text;

  String get audioUrl => _node
      .findElements('enclosure')
      .first
      .attributes
      .firstWhere((e) => e.name.local == 'url')
      .value;
}
