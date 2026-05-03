import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  Color textColor;

  MyText({super.key, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
