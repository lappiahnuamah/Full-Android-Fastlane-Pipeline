import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savyminds/resources/app_colors.dart';

class CustomTheme {
  ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFF63E49),
      useMaterial3: false,
      scaffoldBackgroundColor: AppColors.kScaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.kScaffoldBackground,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: AppColors.kBorderColor),
        ),
        foregroundColor: AppColors.kSecondaryColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.kTopBarColor,
        ),
      ),
      canvasColor: AppColors.kScaffoldBackground,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.kPrimaryColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(),
        bodyMedium: TextStyle(),
      ).apply(
          displayColor: AppColors.kTextColor, bodyColor: AppColors.kTextColor),
      fontFamily: 'Inter');

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.kDarkPrimaryColor,
    scaffoldBackgroundColor: AppColors.kDarkScaffoldBackground,
    useMaterial3: false,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.kDarkAppBarColor,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.kDarkTopBarColor,
      ),
      shape: Border(
        bottom: BorderSide(color: AppColors.kDarkTopBarColor),
      ),
    ),
    canvasColor: AppColors.kPlaceholderColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
    ).apply(
        displayColor: AppColors.kDarkPrimaryColor,
        bodyColor: AppColors.kDarkPrimaryColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.kPrimaryColor,
        foregroundColor: Colors.white),
    fontFamily: 'Inter',
  );
}
