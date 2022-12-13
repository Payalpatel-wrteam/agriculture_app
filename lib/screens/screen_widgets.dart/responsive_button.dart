import 'package:flutter/material.dart';

import '../../helper/design_config.dart';

class ResponsiveButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final bool? isResponsive;
  final VoidCallback onPressed;
  final Color? color;
  final BoxShadow? shadow;
  final double? radius;
  const ResponsiveButton(
      {Key? key,
      this.width,
      this.height,
      required this.child,
      required this.onPressed,
      this.isResponsive = false,
      this.color,
      this.radius,
      this.shadow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 55, //50
        // padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            boxShadow: shadow != null ? [shadow!] : null,
            borderRadius:
                BorderRadius.all(Radius.circular(radius ?? buttonRadius)),
            color: color ?? Theme.of(context).primaryColor),
        child: child,
      ),
    );
  }
}
