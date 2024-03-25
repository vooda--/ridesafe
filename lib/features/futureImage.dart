import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/providers/ride_safe_provider.dart';

class FutureImage extends StatelessWidget {
  final int? id;
  final double width;
  final double? height;
  final BoxFit fit;

  const FutureImage({
    super.key,
    required this.id,
    required this.width,
    this.height,
    required this.fit,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RideSafeProvider>(context, listen: false);
    final imageUrl = id?.toString() ?? '';

    return FutureBuilder<Uint8List>(
      future: provider.getImage(context, id) ??
          Future.value(Uint8List.fromList([])), // Empty image data as default
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting
          return SizedBox(
              width: width,
              height: height,
              child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          // Display error message on error
          return SizedBox(
              width: width,
              height: height,
              child: Text('Error: ${snapshot.error}'));
        } else {
          final imageData = snapshot.data ?? Uint8List.fromList([]);
          return Image.memory(imageData, width: width, height: height, fit: fit);
        }
      },
    );
  }
}
