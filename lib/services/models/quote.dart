import 'dart:ffi';

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

  Quote(
      {this.image,
      this.url,
      this.youtubeUrl,
      this.tags,
      this.content,
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
