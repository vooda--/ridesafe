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
