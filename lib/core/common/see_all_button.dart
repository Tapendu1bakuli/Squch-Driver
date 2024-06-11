import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';
import '../utils/app_strings.dart';
import '../utils/const.dart';
import '../utils/fonts.dart';

class SeeAllButton extends StatelessWidget {
  late Function()? onTap;
  final Color? color;
  final TextStyle? textStyle;

  SeeAllButton(
      {this.onTap,
        this.color,
        this.textStyle,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(AppStrings.SeeAll,
        style: textStyle??CustomTextStyle(
            fontSize: 12.fss,
            fontWeight: FontWeight.w800,
            color: color??Colors.grey
        ),
        overflow: TextOverflow.clip,),
    );
  }
}