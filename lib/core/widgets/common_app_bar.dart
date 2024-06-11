import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/utils/app_colors.dart';
import 'package:squch_driver/core/utils/fonts.dart';
import 'package:squch_driver/core/utils/image_utils.dart';
import 'package:squch_driver/core/widgets/horizontal_gap.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  String? title;
  Function? onPressed;
  bool isIconShow;
  bool centerTitle;
  bool? appIconVisible;
  double? topPading;
  Icon? icon;
  List<Widget>? action;

  CommonAppbar({
    this.title,
    this.onPressed,
    this.appIconVisible,
    this.isIconShow = false,
    this.centerTitle = false,
    this.icon,
    this.topPading,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      actions: action,
      backgroundColor: Theme.of(context).brightness != Brightness.dark
          ? AppColors.colorOffWhite
          : AppColors.titleColor,
      iconTheme: IconThemeData(
        color: Theme.of(context).brightness != Brightness.dark
            ? AppColors.colorWhite
            : AppColors.titleColor, // Set the color of icons
        size: 20.ss, // Set the size of icons
        // You can set more properties like opacity, etc. if needed
      ),
      centerTitle: centerTitle,
      title: appIconVisible!= null && appIconVisible == true?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(
                  Radius.circular(10.ss))),
              child: Image.asset(ImageUtils.appIcon,width: 24,height: 24,)),
          HorizontalGap(10.ss),
          Text(
            title ?? "",
            style: CustomTextStyle(
                color: Theme.of(context).brightness != Brightness.dark
                    ? AppColors.titleColor
                    : AppColors.colorWhite,
                fontSize: 16.fss,
                fontWeight: FontWeight.w700),
            overflow: TextOverflow.clip,
          ),
        ],
      ):
      Text(
        title ?? "",
        style: CustomTextStyle(
            color: Theme.of(context).brightness != Brightness.dark
                ? AppColors.titleColor
                : AppColors.colorWhite,
            fontSize: 16.fss,
            fontWeight: FontWeight.w700),
        overflow: TextOverflow.clip,
      ),
      elevation: 0,
      titleSpacing: 0,
      leading: isIconShow == true
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: icon??Icon(Icons.arrow_back_ios_new_outlined,
                      color: Theme.of(context).brightness != Brightness.dark
                          ? AppColors.titleColor
                          : AppColors.colorWhite,
                      size: 16.ss),
                  onTap: () {
                    if (onPressed != null) {
                      onPressed!();
                    } else {
                      Get.back();
                    }
                  },
                ),
              ],
            )
          : Offstage(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
