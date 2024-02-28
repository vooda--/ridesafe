import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/bottom_menu/bottom_mixin/bottom_mixin.dart';

class BottomNavigationMenu extends StatelessWidget {
  late final BottomMenuLogic menuLogic;
  late final ScrollController controller;

  void Function()? onAddToFavoriteClick;
  void Function()? onShareClick;
  void Function()? onSearchClick;
  void Function(String filter)? searchCallback;

  BottomNavigationMenu(
      {Key? key,
      required this.controller,
      this.onAddToFavoriteClick,
      this.onSearchClick,
      this.searchCallback,
      this.onShareClick})
      : super(key: key) {
    onAddToFavoriteClick ??= () {};
    onShareClick ??= () {};
    onSearchClick ??= () {};
    searchCallback ??= (String filter) {};
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomMenuLogic>(
      builder: (context, menuLogic, child) {
        menuLogic.setListener(controller, context);

        return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 50.0,
            child: Column(
              children: [
                Visibility(
                  visible: menuLogic.searchIsVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                        onChanged: (value) {
                          log('Search $value');
                          searchCallback!(value);
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  searchCallback!('');
                                  menuLogic.toggleSearch();
                                },
                                icon: const Icon(Icons.close)),
                            hintText: 'Search...',
                            border: InputBorder.none)),
                  ),
                ),
                Visibility(
                  visible: menuLogic.isVisible,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset('assets/icons/download.svg',
                                height: 24,
                                width: 24,
                                semanticsLabel: 'Download'),
                          ),
                          // IconButton(
                          //     onPressed: () {
                          //       onSearchClick!();
                          //       menuLogic.toggleSearch();
                          //     },
                          //     icon: const Icon(Icons.search)),
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
                  ),
                ),
              ],
            ));
      },
    );
  }
}
