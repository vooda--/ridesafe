import 'package:flutter/cupertino.dart';

class DownloadProvider extends ChangeNotifier {
  void downloadQuote() {
    notifyListeners();
  }
}
