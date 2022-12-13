import 'package:flutter/material.dart';

class AppLargeText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int maxLines;

  const AppLargeText(
      {Key? key,
      required this.text,
      this.color,
      this.size = 26,
      this.fontWeight = FontWeight.w500,
      this.maxLines = 1,
      this.textAlign = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: size,
        color: color ?? Theme.of(context).primaryColor,
        fontWeight: fontWeight,
      ),

      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      // softWrap: true,
    );
  }
}
