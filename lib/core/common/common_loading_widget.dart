
import 'package:flutter/material.dart';


class CommonLoadingWidget extends StatelessWidget {
  String msg;
  CommonLoadingWidget({required this.msg});
  @override
  Widget build(BuildContext context) {
    return  Center(child:
    Container(child:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 20,),
        Text(msg)
      ],
    )));
  }
}
