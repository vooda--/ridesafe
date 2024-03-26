import 'package:flutter/material.dart';

class AppColors {
    static const primaryColor = Color(0xFF778FF0);
    static const primaryTextColor = Color(0xFF17171A);
    static const secondaryTextColor = Color(0xFFFFFFFF);
    static const grayTextColor = Color(0xFF818181);
    static const whiteColor = Color(0xFFDEDEDE);
    static const lightBlueColor = Color(0xFF54C1EC);
    static const accentColor = Color(0xFFFF00B0);
    static const successColor = Color(0xFF00BF97);
    static const dangerColor = Color(0xFFE33850);
    static const buttonBorderColor = Color(0xFFC2C2C2);
    static const neutrals1 = Color(0xFF17171A);
    static const neutrals3 = Color(0xFF606060);
    static const neutrals4 = Color(0xFF818181);
    static const neutrals5 = Color(0xFF979797);
    static const neutrals8 = Color(0xFFFFFFFF);
    static const secondary1 = Color(0xFFFAF8F3);

}
class AppTextStyles {
    static TextStyle headline5 = const TextStyle(
        fontSize: 24,
        letterSpacing: -0.24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Ubuntu',
        color: AppColors.primaryTextColor,
    );
    static TextStyle hairlineLarge = const TextStyle(
        fontSize: 16,
        letterSpacing: 1,
        fontWeight: FontWeight.bold,
        fontFamily: 'Ubuntu',
        color: AppColors.primaryTextColor,
    );
    static TextStyle bodyNormalBold = const TextStyle(
        fontSize: 16,
        height: 1.5,
        letterSpacing: 1,
        fontWeight: FontWeight.bold,
        fontFamily: 'Ubuntu',
        color: AppColors.primaryTextColor,
    );
    static TextStyle captions = const TextStyle(
        fontSize: 14,
        letterSpacing: 1.4,
        fontWeight: FontWeight.normal,
        fontFamily: 'Ubuntu',
        color: AppColors.neutrals4,
    );
    static TextStyle articleName = const TextStyle(
        fontSize: 12,
        height: 1.5,
        letterSpacing: -0.1,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: AppColors.neutrals8,
    );


}