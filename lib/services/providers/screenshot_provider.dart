import 'package:flutter/cupertino.dart';

class ScreenshotProvider extends ChangeNotifier {
  void shareQuoteScreenshot() {
    notifyListeners();
  }
}
