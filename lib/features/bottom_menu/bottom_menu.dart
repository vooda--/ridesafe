import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/bottom_menu/bottom_mixin/bottom_mixin.dart';
import 'package:ride_safe/services/providers/ride_safe_provider.dart';

class BottomNavigationMenu extends StatelessWidget {
  late final BottomMenuLogic menuLogic;
  late final ScrollController controller;

  void Function()? onAddToFavoriteClick;
  void Function()? onShareClick;
  void Function()? onSearchClick;

  BottomNavigationMenu(
      {Key? key,
      required this.controller,
      this.onAddToFavoriteClick,
      this.onSearchClick,
      this.onShareClick})
      : super(key: key) {
    onAddToFavoriteClick ??= () {};
    onShareClick ??= () {};
    onSearchClick ??= () {};
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomMenuLogic>(
      builder: (context, menuLogic, child) {
        menuLogic.setListener(controller, context);

        return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 56.0,
            child: Column(
              children: [
                Visibility(
                  visible: menuLogic.searchIsVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                        onChanged: (value) {
                          log('Search $value');
                          Provider.of<RideSafeProvider>(context, listen: false)
                              .filterQuotes(value);
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  Provider.of<RideSafeProvider>(context, listen: false)
                                      .filterQuotes(null);
                                  menuLogic.toggleSearch();
                                },
                                icon: const Icon(Icons.close)),
                            hintText: 'Search...',
                            border: InputBorder.none)),
                  ),
                ),
                Visibility(
                  visible: menuLogic.isVisible,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.home)),
                      IconButton(
                          onPressed: () {
                            onSearchClick!();
                            menuLogic.toggleSearch();
                          },
                          icon: const Icon(Icons.search)),
                      IconButton(
                          onPressed: () {
                            onAddToFavoriteClick!();
                          },
                          icon: const Icon(Icons.favorite)),
                      IconButton(
                          onPressed: () {
                            onShareClick!();
                          },
                          icon: const Icon(Icons.share)),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }
}
