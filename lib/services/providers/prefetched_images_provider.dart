
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ride_safe/services/api.dart';
import 'package:ride_safe/services/hive_service.dart';
import 'package:ride_safe/services/models/prefetchedImage.dart';

class PrefetchedImagesProvider with ChangeNotifier {
  final API apiService;
  final HiveService hiveService;

  String filter = '';
  String articleFilter = '';

  PrefetchedImagesProvider(this.hiveService, this.apiService);

  Future<List<PrefetchedImage>> randomImages(BuildContext context, int number) {
    // var isLandscape =
    //     MediaQuery.of(context).orientation == Orientation.landscape;
    return apiService
        .fetchRandomImages('portrait', number)
        .then((value) {
      return value;
    });
  }

}