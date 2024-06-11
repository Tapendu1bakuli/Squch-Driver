import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';
import '../../../core/common/common_button.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/gap.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateRidePage extends StatefulWidget {
  String total;
  String tripCharge;
  String subTotal;
  String rounding;
  String bookingFee;
  String ridePromotion;
  String paidBy;
  String date;
  String time;
  String payments;

  RateRidePage(
      {super.key,
      required this.bookingFee,
      required this.rounding,
      required this.date,
      required this.paidBy,
      required this.payments,
      required this.ridePromotion,
      required this.subTotal,
      required this.time,
      required this.total,
      required this.tripCharge});

  @override
  State<RateRidePage> createState() => _RateRidePageState();
}

class _RateRidePageState extends State<RateRidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.ss, vertical: 20.ss),
        child: ListView(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 36.ss,
                    width: 36.ss,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.colorInviteFriendHome),
                    child: SvgPicture.asset(ImageUtils.cancelIcon),
                  ),
                ),
                Container(
                  width: 90.ss,
                ),
                Text(
                  AppStrings.rateYourRide,
                  style: CustomTextStyle(
                      fontSize: 16.fss,
                      fontWeight: FontWeight.w900,
                      color: AppColors.titleColor),
                ),
              ],
            ),
            Gap(20.ss),
            Center(
              child: SvgPicture.asset(ImageUtils.thumbsUp),
            ),
            Gap(20.ss),
            Center(
              child: Text(
                AppStrings.awesome,
                style: CustomTextStyle(
                    fontSize: 20.fss,
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Gap(10.ss),
            Center(
              child: Text(
                AppStrings.anotherRideCompleted,
                style: CustomTextStyle(
                    fontSize: 14.fss,
                    color: AppColors.rateDriverTopSecondTextColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Gap(20.ss),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.total,
                  style: CustomTextStyle(
                      fontSize: 24.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.total,
                  style: CustomTextStyle(
                      fontSize: 24.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Gap(10.ss),
            const Divider(
              color: AppColors.bottomNavigationUnselectedColor,
            ),
            Gap(10.ss),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.tripCharge,
                  style: CustomTextStyle(
                      fontSize: 16.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  widget.tripCharge,
                  style: CustomTextStyle(
                      fontSize: 16.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Gap(10.ss),
            const Divider(
              color: AppColors.bottomNavigationUnselectedColor,
            ),
            Gap(10.ss),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.subtotal,
                  style: CustomTextStyle(
                      fontSize: 16.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  widget.subTotal,
                  style: CustomTextStyle(
                      fontSize: 16.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Gap(10.ss),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.rounding,
                  style: CustomTextStyle(
                      fontSize: 16.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  widget.rounding,
                  style: CustomTextStyle(
                      fontSize: 16.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Gap(10.ss),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.bookingFee,
                  style: CustomTextStyle(
                      fontSize: 16.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  widget.bookingFee,
                  style: CustomTextStyle(
                      fontSize: 16.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Gap(10.ss),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.riderPromotion,
                  style: CustomTextStyle(
                      fontSize: 16.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  widget.ridePromotion,
                  style: CustomTextStyle(
                      fontSize: 16.fss,
                      color: AppColors.switcherOnlineColor,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Gap(10.ss),
            const Divider(
              color: AppColors.bottomNavigationUnselectedColor,
            ),
            Gap(10.ss),
            Text(
              AppStrings.payments,
              style: CustomTextStyle(
                  fontSize: 16.fss,
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w700),
            ),
            Gap(10.ss),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${AppStrings.paidBy}${widget.paidBy}",
                      style: CustomTextStyle(
                          fontSize: 13.fss,
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "${widget.date} ${widget.time}",
                      style: CustomTextStyle(
                          fontSize: 12.fss,
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  widget.payments,
                  style: CustomTextStyle(
                      fontSize: 13.fss,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Gap(20.ss),
            Center(
              child: Text(
                AppStrings.rateYourExperience,
                style: CustomTextStyle(
                    fontSize: 16.fss,
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Gap(10.ss),
            Center(
              child: RatingBar(
                initialRating: 5,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Image.asset(ImageUtils.starFilled),
                  half: Image.asset(ImageUtils.starFilled),
                  empty: Image.asset(ImageUtils.starOutline),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ),
            Gap(20.ss),
            CommonButton(
              label: AppStrings.done.tr,
              onClicked: () {
                Get.back();
              },
            ),
            Gap(20.ss),
          ],
        ),
      ),
    );
  }
}
