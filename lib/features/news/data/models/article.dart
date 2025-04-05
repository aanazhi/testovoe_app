import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Article {
  @HiveField(0)
  final String? url;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? urlToImage;

  @HiveField(4)
  final String? publishedAt;

  Article({
    this.url,
    this.title,
    this.description,
    this.urlToImage,
    this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
