import 'dart:collection';

import 'package:hive/hive.dart';
import 'package:ride_safe/services/models/question.dart';
import 'package:ride_safe/services/models/quiz_category.dart';
import 'package:ride_safe/services/models/image.dart';

class Quiz {
  final int id;
  final String? author;
  final String? tags;
  final Image? image;
  final Set<Image> images = HashSet<Image>();
  final bool draft;
  final bool hidden;
  final QuizCategory quizCategory;
  final String title;
  final String? description;
  final List<Question>? content;

  Quiz({required this.id,
    this.author,
    this.tags,
    this.image,
    required this.draft,
    required this.hidden,
    required this.quizCategory,
    required this.title,
    this.description,
    this.content});

  factory Quiz.fromJson(Map<String, dynamic> json) =>
      Quiz(
        id: json["id"],
        tags: json["tags"],
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
        draft: json["draft"],
        hidden: json["hidden"],
        quizCategory: QuizCategory.fromJson(json["quizCategory"]),
        title: json["title"],
        description: json["description"] ?? '',
        content: List.from(json["content"]).map((e) {
          return Question.fromJson(e);
        }).toList(growable: false),
        author: json["author"]?? '',
      );
}

class QuizAdapter extends TypeAdapter<Quiz> {
  @override
  final typeId = 4;

  @override
  Quiz read(BinaryReader reader) {
    return Quiz(
        id: reader.read(),
        tags: reader.read(),
        image: reader.read(),
        draft: reader.read(),
        hidden: reader.read(),
        quizCategory: reader.read(),
        title: reader.read(),
        description: reader.read(),
        content: reader.read());
  }

  @override
  void write(BinaryWriter writer, Quiz obj) {
    writer.write(obj.id);
    writer.write(obj.tags);
    writer.write(obj.image);
    writer.write(obj.draft);
    writer.write(obj.hidden);
    writer.write(obj.quizCategory);
    writer.write(obj.title);
    writer.write(obj.description);
    writer.write(obj.content);
  }
}