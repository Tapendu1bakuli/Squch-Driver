import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';
class CommonBackButton extends StatelessWidget {
  const CommonBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(top: 20.ss),
        child: Container(
          height: 30.ss,
            width: 30.ss,

            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Icon(Icons.arrow_back,size: 16,color: Colors.grey,)
        ),
      ),
      onTap: (){Get.back();},
    );
  }
}
