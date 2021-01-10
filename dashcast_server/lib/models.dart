import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class Podcast {
  final int id;

  final String title;

  final String imageUrl;

  Podcast({
    this.id,
    this.title,
    this.imageUrl,
  });

  factory Podcast.fromDetails(PodcastDetails details) =>
      Podcast(id: details.id, title: details.title, imageUrl: details.imageUrl);

  factory Podcast.fromJson(Map<String, dynamic> json) =>
      _$PodcastFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastToJson(this);
}

@JsonSerializable()
class PodcastDetails extends Podcast {
  final String rssFeedUrl;

  final List<Episode> episodes;

  PodcastDetails(
      {int id, String title, String imageUrl, this.rssFeedUrl, this.episodes})
      : super(id: id, title: title, imageUrl: imageUrl);

  factory PodcastDetails.fromJson(Map<String, dynamic> json) =>
      _$PodcastDetailsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PodcastDetailsToJson(this);
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

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}

@JsonSerializable()
class PodcastListResponse {
  final List<Podcast> podcasts;

  PodcastListResponse({this.podcasts});

  factory PodcastListResponse.fromJson(Map<String, dynamic> json) =>
      _$PodcastListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastListResponseToJson(this);
}
