import 'package:hive_flutter/hive_flutter.dart';
import 'package:ride_safe/services/models/image.dart';

class ArticleCategory {
  final int id;
  final Image? image;
  final int? order;
  final String title;
  final String? description;

  ArticleCategory(
      {required this.id,
      this.image,
      this.order,
      required this.title,
      this.description});

  factory ArticleCategory.fromJson(Map<String, dynamic> json) =>
      ArticleCategory(
        id: json["id"],
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
        order: json["order"],
        title: json["title"],
        description: json["description"],
      );
}
class ArticleCategoryAdapter extends TypeAdapter<ArticleCategory> {
  @override
  final typeId = 2;

  @override
  ArticleCategory read(BinaryReader reader) {
    return ArticleCategory(
      id: reader.read(),
      image: reader.read(),
      order: reader.read(),
      title: reader.read(),
      description: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ArticleCategory obj) {
    writer.write(obj.id);
    writer.write(obj.image);
    writer.write(obj.order);
    writer.write(obj.title);
    writer.write(obj.description);
  }
}
