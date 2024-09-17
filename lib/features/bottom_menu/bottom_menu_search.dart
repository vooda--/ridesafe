import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/bottom_menu/bottom_mixin/bottom_mixin.dart';

class BottomSearchMenu extends StatelessWidget {
  late final BottomMenuLogic menuLogic;
  late final ScrollController controller;

  void Function()? onSearchClick;
  void Function(String filter)? searchCallback;

  BottomSearchMenu(
      {Key? key,
      required this.controller,
      this.onSearchClick,
      this.searchCallback,
      })
      : super(key: key) {
    onSearchClick ??= () {};
    searchCallback ??= (String filter) {};
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Consumer<BottomMenuLogic>(
      builder: (context, menuLogic, child) {
        menuLogic.setListener(controller, context);

        return Container(
          height: 60.0 + keyboardHeight,
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
        );
      },
    );
  }
}
