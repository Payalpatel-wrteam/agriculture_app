import 'package:flutter/material.dart';

import '../helper/colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backColor,
    secondaryHeaderColor: AppColors.whiteShade,
    dividerTheme: DividerThemeData(
      color: const Color(0xff707070).withOpacity(0.17),
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
        ),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryColor)),
    hintColor: AppColors.whiteColor,
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 18,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.primaryColor),
    dialogTheme: const DialogTheme(
      alignment: Alignment.center,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18))),
    ),
  );
}
