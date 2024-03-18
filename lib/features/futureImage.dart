import 'dart:typed_data';
import 'package:flutter/material.dart';

class FutureImage extends StatelessWidget {
  final Future<Uint8List> image;
  final double width;
  final double? height;
  final BoxFit fit;

  const FutureImage(this.image,
      {super.key,
      required this.width, this.height,
      required this.fit});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: image,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is still running, you can show a loading indicator.
          return SizedBox(
              width: width,
              height: height,
              child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          // If there was an error, you can display an error message.
          return SizedBox(
              width: width,
              height: height,
              child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // If the future completed successfully, display the loaded image.
          return Image.memory(snapshot.data!,
              width: width, height: height, fit: fit);
        } else {
          // Handle other cases as needed.
          return SizedBox(
              width: width,
              height: height,
              child: const Text('No data available.'));
        }
      },
    );
  }
}
