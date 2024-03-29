
import 'dart:typed_data';

import 'package:hive/hive.dart';

class Quote extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  String? image;
  @HiveField(2)
  final String? url;
  @HiveField(3)
  final String? youtubeUrl;
  @HiveField(4)
  final String? tags;
  @HiveField(5)
  final String? content;
  @HiveField(6)
  final bool draft;
  @HiveField(7)
  final bool hidden;
  @HiveField(8)
  final String quoteText;
  @HiveField(9)
  final String author;
  @HiveField(10)
  Uint8List? imageBytes;

  Quote(
      {this.image,
      this.url,
      this.youtubeUrl,
      this.tags,
      this.content,
      this.imageBytes,
      required this.draft,
      required this.hidden,
      required this.id,
      required this.quoteText,
      required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        id: json["id"],
        image: json["image"],
        url: json["url"],
        youtubeUrl: json["youtubeUrl"],
        tags: json["tags"],
        content: json["content"],
        draft: json["draft"],
        hidden: json["hidden"],
        quoteText: json["quoteText"],
        author: json["author"],
      );
}

class QuoteAdapter extends TypeAdapter<Quote> {
  @override
  final typeId = 0;

  @override
  Quote read(BinaryReader reader) {
    return Quote(
      id: reader.read(),
      image: reader.read(),
      url: reader.read(),
      youtubeUrl: reader.read(),
      tags: reader.read(),
      content: reader.read(),
      draft: reader.read(),
      hidden: reader.read(),
      quoteText: reader.read(),
      author: reader.read(),
      imageBytes: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Quote obj) {
    writer.write(obj.id);
    writer.write(obj.image);
    writer.write(obj.url);
    writer.write(obj.youtubeUrl);
    writer.write(obj.tags);
    writer.write(obj.content);
    writer.write(obj.draft);
    writer.write(obj.hidden);
    writer.write(obj.quoteText);
    writer.write(obj.author);
    writer.write(obj.imageBytes);
  }
}