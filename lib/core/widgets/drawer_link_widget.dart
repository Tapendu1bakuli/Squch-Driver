/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/utils/fonts.dart';

class DrawerLinkWidget extends StatelessWidget {
  final String? icon;
  final String? text;
  final ValueChanged<void>? onTap;

  const DrawerLinkWidget({
    Key? key,
    this.icon,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!('');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,),
        child: Row(
          children: [
            SvgPicture.asset(icon ?? "",width: 22.ss,height: 22.ss,),
            Container(width: 10.ss,),
            Expanded(
              child: Text(text??"".tr,
                  style:
                  CustomTextStyle(fontSize: 16.fss,fontWeight: FontWeight.w500),
            ),
            )
          ],
        ),
      ),
    );
  }
}
