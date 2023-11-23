import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class BottomMenuLogic extends ChangeNotifier {
  bool _isVisible = true;
  bool _searchIsVisible = false;
  late final ScrollController controller;
  late final BuildContext context;

  bool get isVisible => _isVisible;

  bool get searchIsVisible => _searchIsVisible;

  setListener(controller, context) {
    controller.addListener(_listen);
  }

  @override
  void dispose() {
    controller.removeListener(_listen);
    controller.dispose();
  }

  void _listen() {
    final ScrollDirection direction =
        Scrollable.of(context).position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      _show();
    } else if (direction == ScrollDirection.reverse) {
      _hide();
    }
    notifyListeners();
  }

  void toggleSearch() {
    log('Toggle search $_searchIsVisible');
    _searchIsVisible = !_searchIsVisible;
    _isVisible = !_isVisible;
    notifyListeners();
  }

  void _show() {
    if (!_isVisible) {
      _isVisible = true;
    }
  }

  void _hide() {
    if (!_isVisible) {
      _isVisible = false;
    }
  }
}
