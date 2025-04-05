import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class Comment {
  @HiveField(0)
  final String articleUrl;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final String text;

  @HiveField(3)
  final DateTime createdAt;

  Comment({
    required this.articleUrl,
    required this.author,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
