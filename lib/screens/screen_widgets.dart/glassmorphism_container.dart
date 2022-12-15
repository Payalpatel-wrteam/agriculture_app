import 'dart:ui';

import 'package:flutter/material.dart';

import '../../helper/colors.dart';
import '../../helper/constant.dart';

class GlassmorphismContainer extends StatelessWidget {
  final Widget child;
  const GlassmorphismContainer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('${Constants.imagePath}login_bg.jpeg'),
        fit: BoxFit.cover,
      )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            // height: 400,
            width: MediaQuery.of(context).size.width - 40,
            // margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white60, Colors.white10]),
                color: AppColors.whiteColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(width: 2, color: Colors.white30)),
            child: child,
          ),
        ),
      ),
    );
  }
}
