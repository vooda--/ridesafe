import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/bottom_menu/bottom_mixin/bottom_mixin.dart';

class BottomNavigationMenu extends StatelessWidget {
  late final BottomMenuLogic menuLogic;
  late final ScrollController controller;

  void Function()? onAddToFavoriteClick;

  BottomNavigationMenu(
      {Key? key, required this.controller, this.onAddToFavoriteClick})
      : super(key: key) {
    onAddToFavoriteClick ??= () {};
  }

  @override
  Widget build(BuildContext context) {
    menuLogic = BottomMenuLogic(controller, context);

    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: menuLogic.isVisible ? 56.0 : 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(onPressed: () {}, icon: Icon(Icons.home)),
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  onAddToFavoriteClick!();
                },
                icon: Icon(Icons.favorite)),
            IconButton(onPressed: () {}, icon: Icon(Icons.person)),
          ],
        ));
  }
}
