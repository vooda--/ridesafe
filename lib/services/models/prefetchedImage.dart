import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

@HiveType(typeId: 7)
class PrefetchedImage extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final Uint8List data;

  PrefetchedImage({required this.name, required this.data});

  factory PrefetchedImage.fromJson(Map<String, dynamic> json) {
    final base64Data = json["imageBytes"] as String;
    final imageBytes = base64Decode(base64Data); // Decode base6
    return PrefetchedImage(name: json["imagePath"], data: imageBytes);
  }
}

class ImageAdapter extends TypeAdapter<PrefetchedImage> {
  @override
  final typeId = 6;

  @override
  PrefetchedImage read(BinaryReader reader) {
    return PrefetchedImage(name: reader.read(), data: reader.read());
  }

  @override
  void write(BinaryWriter writer, PrefetchedImage obj) {
    writer.write(obj.name);
    writer.write(obj.data.buffer.asUint8List());
  }
}
