import 'package:flutter/material.dart';

class AppColors {
    static const primaryColor = Color(0xFF778FF0);
    static const primaryTextColor = Color(0xFF17171A);
    static const grayTextColor = Color(0xFF818181);
    static const whiteColor = Color(0xFFDEDEDE);
    static const lightBlueColor = Color(0xFF54C1EC);
    static const accentColor = Color(0xFFFF00B0);
    static const successColor = Color(0xFF00BF97);
    static const dangerColor = Color(0xFFE33850);
    static const buttonBorderColor = Color(0xFFC2C2C2);
}
class AppTextStyles {
    static TextStyle headline5 = const TextStyle(
        fontSize: 24,
        letterSpacing: -0.24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Ubuntu',
        color: AppColors.primaryTextColor,
    );
}