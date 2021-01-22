// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Podcast _$PodcastFromJson(Map<String, dynamic> json) {
  return Podcast(
    id: json['id'] as int,
    title: json['title'] as String,
    imageUrl: json['imageUrl'] as String,
    link: json['link'] as String,
  );
}

Map<String, dynamic> _$PodcastToJson(Podcast instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'link': instance.link,
    };

PodcastDetails _$PodcastDetailsFromJson(Map<String, dynamic> json) {
  return PodcastDetails(
    id: json['id'] as int,
    title: json['title'] as String,
    imageUrl: json['imageUrl'] as String,
    link: json['link'] as String,
    rssFeedUrl: json['rssFeedUrl'] as String,
    episodes: (json['episodes'] as List)
        ?.map((e) =>
            e == null ? null : Episode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PodcastDetailsToJson(PodcastDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'link': instance.link,
      'rssFeedUrl': instance.rssFeedUrl,
      'episodes': instance.episodes,
    };

Episode _$EpisodeFromJson(Map<String, dynamic> json) {
  return Episode(
    id: json['id'] as int,
    title: json['title'] as String,
    audioUrl: json['audioUrl'] as String,
    publishDate: json['publishDate'] == null
        ? null
        : DateTime.parse(json['publishDate'] as String),
    podcast: json['podcast'] == null
        ? null
        : Podcast.fromJson(json['podcast'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'audioUrl': instance.audioUrl,
      'publishDate': instance.publishDate?.toIso8601String(),
      'podcast': instance.podcast,
    };

PodcastListResponse _$PodcastListResponseFromJson(Map<String, dynamic> json) {
  return PodcastListResponse(
    podcasts: (json['podcasts'] as List)
        ?.map((e) =>
            e == null ? null : Podcast.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PodcastListResponseToJson(
        PodcastListResponse instance) =>
    <String, dynamic>{
      'podcasts': instance.podcasts,
    };
