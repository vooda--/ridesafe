class Image {
  final int id;
  final String name;
  final String pathToFile;
  final int? articleId;
  final int? quoteId;

  Image(
      {required this.id,
      required this.name,
      required this.pathToFile,
      required this.articleId,
      required this.quoteId});

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        name: json["name"],
        pathToFile: json["pathToFile"],
        articleId: json["articleId"],
        quoteId: json["quoteId"],
      );
}
