
import 'package:flutter/material.dart';


class CommonNoItemFoundWidget extends StatelessWidget {
  String msg;
  CommonNoItemFoundWidget({required this.msg});
  @override
  Widget build(BuildContext context) {
    return  Center(child:
    Container(
      alignment: Alignment.center,
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(msg)
      ],
    )));
  }
}
