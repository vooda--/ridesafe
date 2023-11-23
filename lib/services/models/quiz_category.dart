import 'package:hive_flutter/hive_flutter.dart';
import 'package:ride_safe/services/models/image.dart';

class QuizCategory {
  final int id;
  final Image? image;
  final int? order;
  final String title;
  final String? description;

  QuizCategory(
      {required this.id,
      this.image,
      this.order,
      required this.title,
      this.description});

  factory QuizCategory.fromJson(Map<String, dynamic> json) =>
      QuizCategory(
        id: json["id"],
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
        order: json["order"],
        title: json["title"],
        description: json["description"],
      );
}
class QuizCategoryAdapter extends TypeAdapter<QuizCategory> {
  @override
  final typeId = 5;

  @override
  QuizCategory read(BinaryReader reader) {
    return QuizCategory(
      id: reader.read(),
      image: reader.read(),
      order: reader.read(),
      title: reader.read(),
      description: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizCategory obj) {
    writer.write(obj.id);
    writer.write(obj.image);
    writer.write(obj.order);
    writer.write(obj.title);
    writer.write(obj.description);
  }
}
