import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';

import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/fonts.dart';
import '../utils/image_utils.dart';
import 'dash_line_view.dart';
import 'gap.dart';

class LoaderWidget extends StatelessWidget {
  String? title;
  String? subTitle;
  String? buttonText;
  Function()? onButtonClick;
  bool? enableButton;

  LoaderWidget(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.buttonText,
      required this.onButtonClick,
      this.enableButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          /* horizontal: 20.ss,*/
          vertical: 20.ss),
      decoration: BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.ss),
            topLeft: Radius.circular(15.ss),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
              child: Container(
            height: 5.ss,
            width: 80.ss,
            color: AppColors.colorgrey,
            padding: EdgeInsets.symmetric(vertical: 10.ss),
          )),
          Gap(10.ss),
          Text(
            title ?? AppStrings.connectingYouToACustomer.tr,
            style: CustomTextStyle(
                fontSize: 16.fss,
                fontWeight: FontWeight.w900,
                color: AppColors.titleColor),
          ),
          Gap(20.ss),
          Divider(
            color: AppColors.colordivider,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.ss, vertical: 20.ss),
            child: DashLineView(
              fillRate: 0,
            ),
          ),
          ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(30.ss)),
              child: SvgPicture.asset(ImageUtils.driverLoader)),
          Gap(10.ss),
          Divider(
            color: AppColors.colordivider,
          ),
          Gap(10.ss),
          Text(
            subTitle ?? "",
            style: CustomTextStyle(
                fontSize: 14.fss,
                fontWeight: FontWeight.w400,
                color: AppColors.titleColor),
          ),
          Gap(10.ss),
          Divider(
            color: AppColors.colordivider,
          ),
          Gap(20.ss),
          enableButton ?? false
              ? InkWell(
                  onTap: onButtonClick ?? () {},
                  child: Text(
                    buttonText ?? AppStrings.cancelRide.tr,
                    style: CustomTextStyle(
                        fontSize: 14.fss,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textRed),
                  ),
                )
              : const Offstage(),
        ],
      ),
    );
  }
}
