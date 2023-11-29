import 'package:flutter/material.dart';

class AppColors {
    static const primaryColor = 0xFF778FF0;
    static const primaryTextColor = 0xFF17171A;
    static const secondaryColor = 0xFFDEDEDE;
    static const accentColor = 0xFF00B0;
    static const successColor = 0x00BF97;
    static const dangerColor = 0xE33850;
    static const buttonBorderColor = 0xFFC2C2C2;
}
class AppTextStyles {
    static TextStyle headline5 = const TextStyle(
        fontSize: 24,
        letterSpacing: -0.24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Ubuntu',
        color: Color(AppColors.primaryTextColor),
    );
}