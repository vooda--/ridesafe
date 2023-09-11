import 'dart:collection';

import 'package:hive/hive.dart';
import 'package:ride_safe/services/models/article_category.dart';
import 'package:ride_safe/services/models/image.dart';

class Article {
  final int id;
  final int? order;
  final String? author;
  final String? tags;
  final Image? image;
  final Set<Image> images = HashSet<Image>();
  final bool draft;
  final bool hidden;
  final ArticleCategory articleCategory;
  final String title;
  final String? url;
  final String? youtubeUrl;
  final String? description;
  final String? content;

  Article({required this.id,
    this.order,
    this.author,
    this.tags,
    this.image,
    required this.draft,
    required this.hidden,
    required this.articleCategory,
    required this.title,
    this.url,
    this.youtubeUrl,
    this.description,
    this.content});

  factory Article.fromJson(Map<String, dynamic> json) =>
      Article(
        id: json["id"],
        order: json["order"],
        tags: json["tags"],
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
        draft: json["draft"],
        hidden: json["hidden"],
        articleCategory: ArticleCategory.fromJson(json["articleCategory"]),
        title: json["title"],
        url: json["url"] ?? '',
        youtubeUrl: json["youtubeUrl"] ?? '',
        description: json["description"] ?? '',
        content: json["content"] ?? '',
        author: json["author"]?? '',
      );
}

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final typeId = 1;

  @override
  Article read(BinaryReader reader) {
    return Article(
        id: reader.read(),
        order: reader.read(),
        tags: reader.read(),
        image: reader.read(),
        draft: reader.read(),
        hidden: reader.read(),
        articleCategory: reader.read(),
        title: reader.read(),
        url: reader.read(),
        youtubeUrl: reader.read(),
        description: reader.read(),
        content: reader.read());
  }


  @override
  void write(BinaryWriter writer, Article obj) {
    writer.write(obj.id);
    writer.write(obj.order);
    writer.write(obj.tags);
    writer.write(obj.image);
    writer.write(obj.draft);
    writer.write(obj.hidden);
    writer.write(obj.articleCategory);
    writer.write(obj.title);
    writer.write(obj.url);
    writer.write(obj.youtubeUrl);
    writer.write(obj.description);
    writer.write(obj.content);
  }
}