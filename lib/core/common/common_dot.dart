

import 'package:flutter/material.dart';



class CommonDot extends StatelessWidget {

  CommonDot(
      { this.height, this.width, required this.mColor, this.borderColor });

  double ? height;
  double? width;
  Color mColor;
  Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:height??10,
      width: width??10,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: borderColor ?? mColor),
          color: mColor
      ),
    );
  }
}
