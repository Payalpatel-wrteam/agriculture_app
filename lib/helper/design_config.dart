import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

const double defaultPadding = 20;
const double defaultMargin = 15;

double buttonHeight = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS
    ? 50
    : 50;
double buttonPadding = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS
    ? 12
    : 17;
double buttonRadius = 12;

const double categoryBoxHeight = 160;
const double categoryBoxWidth = 125;

const double bottomNavBarHeight = 55;

// LinearGradient get appGradient => LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [primaryColor, shadowColor]);

// LinearGradient get reverseGradient => LinearGradient(
//     begin: Alignment.centerRight,
//     end: Alignment.centerLeft,
//     colors: [primaryColor, shadowColor]);

BoxShadow get appShadow => BoxShadow(
      color: AppColors.shadowColor,
      spreadRadius: 0,
      blurRadius: 20,
      offset: Offset(0, 2), // changes position of shadow
    );
BoxShadow get boxShadow => const BoxShadow(
    color: Color(0x29000000),
    offset: Offset(0, 0),
    blurRadius: 6,
    spreadRadius: 0);
const oneSec = Duration(seconds: 1);

Container roundedContainer(
    {required double size, required Color color, required Widget child}) {
  return Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    // padding: EdgeInsets.all(3),
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: color),
    child: child,
  );
}

BorderRadius borderRadius(
    double topLeft, double topRight, double bottomLeft, double bottomRight) {
  return BorderRadius.only(
    topLeft: Radius.circular(topLeft),
    topRight: Radius.circular(topRight),
    bottomLeft: Radius.circular(bottomLeft),
    bottomRight: Radius.circular(bottomRight),
  );
}

BoxDecoration boxDecoration(List<Color> colors) {
  return BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      gradient: LinearGradient(
          begin: const Alignment(0.5, 0),
          end: const Alignment(0.5, 1),
          colors: colors));
}
