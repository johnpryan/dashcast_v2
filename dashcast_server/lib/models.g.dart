// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Podcast _$PodcastFromJson(Map<String, dynamic> json) {
  return Podcast(
    id: json['id'] as int,
    title: json['title'] as String,
    rssFeedUrl: json['rssFeedUrl'] as String,
    imageUrl: json['imageUrl'] as String,
    episodes: (json['episodes'] as List)
        ?.map((e) =>
            e == null ? null : Episode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PodcastToJson(Podcast instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'rssFeedUrl': instance.rssFeedUrl,
      'episodes': instance.episodes,
    };

Episode _$EpisodeFromJson(Map<String, dynamic> json) {
  return Episode(
    id: json['id'] as int,
    title: json['title'] as String,
    audioUrl: json['audioUrl'] as String,
  );
}

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'audioUrl': instance.audioUrl,
    };
