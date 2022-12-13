import 'package:flutter/material.dart';

class CaptionText extends StatelessWidget {
  final String text;
  final Color? color;
  final double size;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final TextOverflow? overflow;
  final TextDecoration textDecoration;
  final int maxLines;

  const CaptionText({
    Key? key,
    required this.text,
    this.color,
    this.size = 12,
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.center,
    this.textDecoration = TextDecoration.none,
    this.maxLines = 1,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color ?? Theme.of(context).secondaryHeaderColor,
        fontWeight: fontWeight,
        decoration: textDecoration,
        fontStyle: FontStyle.normal,
        overflow: overflow ?? TextOverflow.fade,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      // softWrap: true,
    );
  }
}
