import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/fonts.dart';
import 'package:sizing/sizing.dart';

Widget TitleText(BuildContext context, String text,{Color? textColor}){
  return Text(text,
      overflow: TextOverflow.clip,
      style: CustomTextStyle(
      fontSize: 14.fss,
      color: Theme.of(context).brightness != Brightness.dark  ? textColor?? AppColors.titleColor : Colors.white,
      fontWeight: FontWeight.w500
  ));
}