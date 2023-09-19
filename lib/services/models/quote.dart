
import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

class Quote {
  final int id;
  final String? image;
  final String? url;
  final String? youtubeUrl;
  final String? tags;
  final String? content;
  final bool draft;
  final bool hidden;
  final String quoteText;
  final String author;
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