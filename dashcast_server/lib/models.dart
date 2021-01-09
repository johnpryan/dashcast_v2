import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class Podcast {
  final int id;

  final String title;

  final String imageUrl;

  final String rssFeedUrl;

  final List<Episode> episodes;

  Podcast({
    this.id,
    this.title,
    this.rssFeedUrl,
    this.imageUrl,
    this.episodes,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) => _$PodcastFromJson(json);
  Map<String, dynamic> toJson() => _$PodcastToJson(this);
}

@JsonSerializable()
class Episode {
  final int id;
  final String title;
  final String audioUrl;

  Episode({
    this.id,
    this.title,
    this.audioUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
