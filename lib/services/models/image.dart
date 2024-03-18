import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Image {
  final int id;
  final String name;
  final String pathToFile;
  final int? articleId;
  final int? quoteId;
  final int? quizId;

  Image(
      {required this.id,
      required this.name,
      required this.pathToFile,
      this.articleId,
      this.quizId,
      this.quoteId});

  factory Image.fromJson(Map<String, dynamic> json) => Image(
      id: json["id"],
      name: json["name"],
      pathToFile: json["pathToFile"],
      articleId: json["articleId"],
      quoteId: json["quoteId"],
      quizId: json["quizId"]);
}

class ImageAdapter extends TypeAdapter<Image> {
  @override
  final typeId = 6;

  @override
  Image read(BinaryReader reader) {
    return Image(
      id: reader.read(),
      name: reader.read(),
      pathToFile: reader.read(),
      articleId: reader.read(),
      quoteId: reader.read(),
      quizId: reader.read()
    );
  }

  @override
  void write(BinaryWriter writer, Image obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.pathToFile);
    writer.write(obj.articleId);
    writer.write(obj.quoteId);
    writer.write(obj.quizId);
  }
}