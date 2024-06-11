import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/widgets/linear_percent_indicator_widget.dart';
import 'package:squch_driver/core/widgets/rating_with_car_widget.dart';
import 'package:squch_driver/features/dashboard_feature/presentation/controller/dashboard_controller.dart';
import 'package:squch_driver/features/dashboard_feature/widget/share_ride_route_widget.dart';

import '../../features/dashboard_feature/data/models/new_ride_booking_bid_response.dart';
import '../../features/dashboard_feature/widget/ride_route_widget.dart';
import '../../features/map_page_feature/data/models/address_model.dart';
import '../common/common_button.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/fonts.dart';
import '../utils/image_utils.dart';
import 'gap.dart';
import 'horizontal_gap.dart';

class NewBookingCard extends StatelessWidget {
  final Trip? trips;
  final int? tripDuration;
  final Function()? onAccept;
  final String? acceptButtonTitle;
  final String? negotiationButtonTitle;
  final Function()? onNegotiation;
  final Function()? onAnimationEnd;

  NewBookingCard(
      {super.key,
      this.trips,
      this.onAccept,
      this.onNegotiation,
      this.acceptButtonTitle,
      this.negotiationButtonTitle,
      this.onAnimationEnd,
      this.tripDuration});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.ss,
      margin: EdgeInsets.only(top: 20.ss),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.ss)),
        child: Column(
          children: [
            LinearPercentIndicatorWidget(
              animationDuration: tripDuration,
              onAnimationEnd: onAnimationEnd,
              createdAt: trips?.createdAt,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.ss, vertical: 10.ss),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RatingWithCarWidget(
                          profileImage: trips?.customer?.profileImage,
                          rating: trips?.customer?.rating),
                      HorizontalGap(10.ss),
                      Expanded(
                          child: Text(
                        "${trips?.customer?.firstName ?? ""} ${trips?.customer?.lastName ?? ""}",
                        style: CustomTextStyle(
                            color: AppColors.titleColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.fss),
                      )),
                      Text(
                        "${trips?.currencySymbol} ${trips?.price}" ?? "",
                        style: CustomTextStyle(
                            color: AppColors.titleColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.fss),
                      )
                    ],
                  ),
                  Gap(10.ss),
                  Divider(
                    color: AppColors.colordivider,
                  ),
                  (trips?.isMultiStop ?? false)
                      ? ShareRideRouteWidget(
                          source: Address(
                            address: trips?.sceLocation,
                          ),
                          destination: Address(address: trips?.destLocation),
                          multiStop: trips?.stoppages)
                      : RideRouteWidget(
                          sourceAddress: trips?.sceLocation ?? "",
                          destinationAddress: trips?.destLocation ?? "",
                          sourceDistence:
                              "${trips?.sceDistance?.distance?.text ?? ""} away (Pickup)",
                          destinationDistecnce:
                              "${trips?.destDistance?.distance?.text ?? ""} (Drop-off)",
                        ),
                  Divider(
                    color: AppColors.colordivider,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonButton(
                        buttonWidth: MediaQuery.sizeOf(context).width / 2 - 50,
                        buttonHeight: 40.ss,
                        fontSize: 12.fss,
                        onClicked: onAccept ?? () {},
                        label: acceptButtonTitle ?? AppStrings.acceptRide.tr,
                      ),
                      CommonButton(
                        buttonWidth: MediaQuery.sizeOf(context).width / 2 - 50,
                        buttonHeight: 40.ss,
                        solidColor: AppColors.colorbuttongrey,
                        labelColor: AppColors.textBlack,
                        fontSize: 12.fss,
                        onClicked: onNegotiation ?? () {},
                        label:
                            negotiationButtonTitle ?? AppStrings.negotiation.tr,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
