import 'package:flutter/material.dart';

@immutable
class MyColors extends ThemeExtension<MyColors> {
  const MyColors({
     required this.grayBorderColor,
     required this.lightBlueBg,
     required this.blackTextColor,
     required this.grayTextColor,
     required this.whiteTextColor,
     required this.blueBg,
     required this.successBg,
     required this.dangerBg});

  final Color? blueBg;
  final Color? grayBorderColor;
  final Color? lightBlueBg;
  final Color? successBg;
  final Color? dangerBg;
  final Color? blackTextColor;
  final Color? grayTextColor;
  final Color? whiteTextColor;

  @override
  MyColors copyWith() {
    return this;
  }

  @override
  MyColors lerp(MyColors? other, double t) {
    return this;
  }

  // Optional
  @override
  String toString() => 'MyColors()';
}
