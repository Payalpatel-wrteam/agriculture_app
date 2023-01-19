import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  final int? maxLines;
  final TextOverflow? overflow;

  final double? lineSpacing;
  final List<Shadow>? shadows;
  const AppText(
      {Key? key,
      required this.text,
      this.color,
      this.size = 16,
      this.fontWeight = FontWeight.w400,
      this.textAlign = TextAlign.left,
      this.textDecoration = TextDecoration.none,
      this.maxLines,
      this.overflow,
      this.lineSpacing,
      this.shadows})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      style: TextStyle(
          height: lineSpacing ?? 1.0,
          fontSize: size,
          color: color ?? Theme.of(context).primaryColor,
          fontWeight: fontWeight,
          decoration: textDecoration,
          fontStyle: FontStyle.normal,
          overflow: overflow ?? TextOverflow.ellipsis,
          decorationColor: Theme.of(context).primaryColor,
          shadows: shadows),

      textAlign: textAlign,
      maxLines: maxLines,
      // softWrap: true,
    );
  }
}
