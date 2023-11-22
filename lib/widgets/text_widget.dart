import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  TextWidget(
      {Key? key, required this.text, required this.color, this.textSize=20, this.isTitle = false, this.maxLine = 10})
      : super(key: key);

  final String text;
  final Color color;
  final double textSize;
  bool isTitle;
  int maxLine = 10;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      style: TextStyle(overflow: TextOverflow.ellipsis,
          color: color,
          fontSize: textSize,
          fontWeight: isTitle ? FontWeight.bold : FontWeight.normal),
    );
  }}

