import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class BottomMenuLogic {
  bool _isVisible = true;
  final ScrollController controller;
  final BuildContext context;

  bool get isVisible => _isVisible;

  BottomMenuLogic(this.controller, this.context) {
    controller.addListener(_listen);
  }

  @override
  void dispose() {
    controller.removeListener(_listen);
    controller.dispose();
  }

  void _listen() {
    final ScrollDirection direction =
        Scrollable.of(context)!.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      _show();
    } else if (direction == ScrollDirection.reverse) {
      _hide();
    }
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
