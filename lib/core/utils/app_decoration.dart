import 'package:flutter/material.dart';

class AppDecoration {
  static BoxDecoration commonBoxDecoration({double topRight = 20,
    double topLeft = 20,
    double bottomRight = 20,
    double bottomLeft = 20,
    Color color = Colors.white,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
       topRight:  Radius.circular(topRight),
       topLeft:  Radius.circular(topLeft),
       bottomRight:  Radius.circular(bottomRight),
       bottomLeft:  Radius.circular(bottomLeft),

      ),
      boxShadow: [
        BoxShadow(
            color: Colors.blueGrey.withOpacity(0.4),
            offset: const Offset(0.0, 1.0),
            blurRadius: 4.0)
      ],
    );
  }
}
