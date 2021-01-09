import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class Podcast {
  final String title;
  final String url;

  Podcast({
    this.title,
    this.url,
  });
}
