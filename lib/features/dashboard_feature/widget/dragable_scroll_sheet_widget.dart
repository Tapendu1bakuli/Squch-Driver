import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/service/page_route_service/routes.dart';
import '../../../common/widget/flutter_switch.dart';
import '../../../core/common/common_button.dart';
import '../../../core/common/common_text_form_field.dart';
import 'package:badges/badges.dart' as badges;
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/gap.dart';
import '../../../core/widgets/horizontal_gap.dart';
import '../../../core/widgets/linear_percent_indicator_widget.dart';
import '../../../core/widgets/loader_widget.dart';
import '../../../core/widgets/new_booking_card.dart';
import '../../map_page_feature/data/models/address_model.dart';
import '../presentation/controller/dashboard_controller.dart';
import '../presentation/controller/map_state.dart';
import 'ride_route_widget.dart';
import 'share_ride_route_widget.dart';

class DragableScrollSheetWidget extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => getStateView(context));
  }

  Widget getStateView(BuildContext context) {
    switch (controller.mapState.value) {
      case MapState.INITIAL_STATE:
        return const Offstage();

      case MapState.BOOKING_ARRIVED:
        return Obx(
          () => Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            decoration:
                BoxDecoration(color: AppColors.colorBlack.withOpacity(0.3)),
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10.ss),
                itemCount: controller.tripList.length,
                itemBuilder: (BuildContext context, int index) {
                  return NewBookingCard(
                    onNegotiation: () {
                      controller.onNegotiationTrip(
                          trips: controller.tripList[index]);
                    },
                    trips: controller.tripList[index],
                    tripDuration: controller.tripDuration.value,
                    onAccept: () {
                      controller.onAcceptTrip(
                          trips: controller.tripList[index]);
                    },
                    onAnimationEnd: () {
                      controller.onTripAnimationEndTime(
                          trips: controller.tripList[index]);
                    },
                  );
                }),
          ),
        );

      case MapState.ACCEPT_BOOKING_STATE:
        return Obx(
          () => Stack(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration:
                    BoxDecoration(color: AppColors.colorBlack.withOpacity(0.3)),
              ),
              DraggableScrollableSheet(
                  controller: DraggableScrollableController(),
                  initialChildSize: controller.bottomSheetIntSize.value,
                  minChildSize: controller.bottomSheetMinSize.value,
                  maxChildSize: controller.bottomSheetMaxSize.value,
                  expand: true,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                          color: AppColors.colorWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.ss),
                            topLeft: Radius.circular(15.ss),
                          )),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.ss, vertical: 15.ss),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      openDialPad(controller.currentTrip.value
                                              ?.customer?.mobile ??
                                          "");
                                    },
                                    child: CircleAvatar(
                                      child: SvgPicture.asset(ImageUtils.call),
                                      backgroundColor: AppColors.colorGrey,
                                      radius: 20.ss,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "${controller.currentTrip.value.sceDistance?.duration?.text} away",
                                          style: CustomTextStyle(
                                              color: AppColors.textBlack,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20.fss),
                                        ),
                                        Text(
                                          "Picking up ${controller.currentTrip.value.customer?.firstName} ${controller.currentTrip.value.customer?.lastName}",
                                          style: CustomTextStyle(
                                              color: AppColors.textSubBlack,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.fss),
                                        )
                                      ],
                                    ),
                                  ),
                                  Obx(()=> InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.CHAT_SCREEN);
                                        controller.isNewMessageArrived.value = false;
                                      },
                                      child: controller.isNewMessageArrived.value?badges.Badge(
                                        badgeStyle: badges.BadgeStyle(
                                          badgeColor: Colors.red,
                                        ),
                                        position:
                                        badges.BadgePosition.custom(bottom: 22.ss, end: 3.ss),
                                        badgeContent: Text("",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        child: CircleAvatar(
                                            radius: 20.ss,
                                            backgroundColor: AppColors.colorGrey,
                                            child:
                                            SvgPicture.asset(ImageUtils.msg)),
                                      ):CircleAvatar(
                                          radius: 20.ss,
                                          backgroundColor: AppColors.colorGrey,
                                          child:
                                          SvgPicture.asset(ImageUtils.msg)),
                                    ),
                                  )

                                ],
                              ),
                            ),
                            Divider(
                              color: AppColors.colordivider,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.ss, vertical: 10.ss),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: Image.network(controller.currentTrip
                                            .value?.customer?.profileImage ??
                                        ""),
                                    backgroundColor: AppColors.colorGrey,
                                    radius: 20.ss,
                                  ),
                                  HorizontalGap(10.ss),
                                  Expanded(
                                    child: Text(
                                      "${controller.currentTrip.value.customer?.firstName} ${controller.currentTrip.value.customer?.lastName}",
                                      style: CustomTextStyle(
                                          color: AppColors.textBlack,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.fss),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: AppColors.colordivider,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.ss, vertical: 10.ss),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.rideDetails,
                                    style: CustomTextStyle(
                                        color: AppColors.textBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.fss),
                                  ),
                                  Gap(20.ss),
                                  (controller.currentTrip.value?.isMultiStop ??
                                          false)
                                      ? ShareRideRouteWidget(
                                          source: Address(
                                              address: controller.currentTrip
                                                  .value?.sceLocation),
                                          destination: Address(
                                              address: controller.currentTrip
                                                  .value?.destLocation),
                                          multiStop: controller
                                              .currentTrip.value?.stoppages)
                                      : RideRouteWidget(
                                          sourceAddress: controller.currentTrip
                                                  .value?.sceLocation ??
                                              "",
                                          destinationAddress: controller
                                                  .currentTrip
                                                  .value
                                                  ?.destLocation ??
                                              "",
                                          sourceDistence:
                                              "${controller.currentTrip.value?.sceDistance?.distance?.text ?? ""} away (Pickup)",
                                          destinationDistecnce:
                                              "${controller.currentTrip.value?.destDistance?.distance?.text ?? ""} (Drop-off)",
                                        ),
                                ],
                              ),
                            ),
                            Gap(20.ss),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        );

      case MapState.PICKUP_BOOKING_STATE:
        return Obx(
          () => Stack(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration:
                    BoxDecoration(color: AppColors.colorBlack.withOpacity(0.3)),
              ),
              DraggableScrollableSheet(
                  controller: DraggableScrollableController(),
                  initialChildSize: controller.bottomSheetIntSize.value,
                  minChildSize: controller.bottomSheetMinSize.value,
                  maxChildSize: controller.bottomSheetMaxSize.value,
                  expand: true,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20.0.ss),
                            child: Container(
                              padding: EdgeInsets.all(15.ss),
                              height: 50.ss,
                              width: 50.ss,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white),
                              child: SvgPicture.asset("assets/icons/send.svg"),
                            ),
                          ),
                          Gap(20.ss),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              child: Container(
                                // height: size.height*3/4,
                                decoration: BoxDecoration(
                                    color: AppColors.colorWhite,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30.ss),
                                      topLeft: Radius.circular(30.ss),
                                    )),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LinearPercentIndicatorWidget(
                                        animationDuration:
                                            controller.pickupTimerInSec.value *
                                                1000,
                                        onAnimationEnd: () {
                                          controller.showCancle.value =
                                              !controller.showCancle.value;
                                        },
                                        createdAt: DateTime.now().toString(),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.ss, vertical: 15.ss),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap:(){
                                                openDialPad(controller.currentTrip.value
                                                    ?.customer?.mobile ??
                                                    "");
                                              },
                                              child: CircleAvatar(
                                                child: SvgPicture.asset(
                                                    ImageUtils.call),
                                                backgroundColor:
                                                    AppColors.colorGrey,
                                                radius: 20.ss,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    AppStrings
                                                        .waitingForTheRiderMsg
                                                        .tr,
                                                    style: CustomTextStyle(
                                                        color: AppColors
                                                            .textSubBlack,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12.fss),
                                                  ),
                                                  Text(
                                                    "${controller.currentTrip.value.customer?.firstName} ${controller.currentTrip.value.customer?.lastName}",
                                                    style: CustomTextStyle(
                                                        color:
                                                            AppColors.textBlack,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 20.fss),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Obx(()=> InkWell(
                                              onTap: () {
                                                Get.toNamed(Routes.CHAT_SCREEN);
                                                controller.isNewMessageArrived.value = false;
                                              },
                                              child: controller.isNewMessageArrived.value?badges.Badge(
                                                badgeStyle: badges.BadgeStyle(
                                                  badgeColor: Colors.red,
                                                ),
                                                position:
                                                badges.BadgePosition.custom(bottom: 22.ss, end: 3.ss),
                                                badgeContent: Text("",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                child: CircleAvatar(
                                                    radius: 20.ss,
                                                    backgroundColor: AppColors.colorGrey,
                                                    child:
                                                    SvgPicture.asset(ImageUtils.msg)),
                                              ):CircleAvatar(
                                                  radius: 20.ss,
                                                  backgroundColor: AppColors.colorGrey,
                                                  child:
                                                  SvgPicture.asset(ImageUtils.msg)),
                                            ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: AppColors.colordivider,
                                      ),
                                      Gap(10.ss),
                                      Obx(
                                        () => controller.showCancle.isFalse
                                            ? const Offstage()
                                            : InkWell(
                                                onTap: () {
                                                  controller
                                                      .isDriverArrivedToThePickupPoint
                                                      .value = true;
                                                  controller
                                                      .findReasonToCancelRide();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 14.0.ss),
                                                  child: Container(
                                                    width: 347.ss,
                                                    height: 56.ss,
                                                    decoration: ShapeDecoration(
                                                      color: Color(0xFFFDEDED),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      14.0.ss),
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/icons/close-circle.svg",
                                                            height: 24.ss,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 8.ss,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              AppStrings
                                                                  .tapHereToCancelThisRide,
                                                              style: CustomTextStyle(
                                                                  color: AppColors
                                                                      .cancelRideTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      12.fss)),
                                                        ),
                                                        Container(
                                                          width: 60.ss,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right:
                                                                      27.0.ss),
                                                          child: SvgPicture.asset(
                                                              "assets/icons/arrow_right.svg"),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      Gap(20.ss),
                                      Obx(
                                        () => FlutterSwitch(
                                            width: 335.ss,
                                            height: 48.ss,
                                            showOnOff: true,
                                            centerText: true,
                                            inactiveTextColor:
                                                AppColors.colorWhite,
                                            activeTextFontWeight:
                                                FontWeight.w500,
                                            inactiveTextFontWeight:
                                                FontWeight.w500,
                                            inactiveColor:
                                                AppColors.buttonColor,
                                            activeColor: AppColors.buttonColor,
                                            inactiveText:
                                                AppStrings.verifyAndStart.tr,
                                            activeText: "",
                                            inactiveIcon: Icon(
                                              Icons.keyboard_arrow_right,
                                            ),
                                            activeIcon: Icon(
                                              Icons.keyboard_arrow_left,
                                            ),
                                            valueFontSize: 25.0,
                                            toggleSize: 40.0,
                                            value: controller.isArrived.value
                                                ? true
                                                : false,
                                            borderRadius: 12.0,
                                            padding: 4.0,
                                            onToggle: (value) async {
                                              controller.isArrived.value =
                                                  !controller.isArrived.value;
                                              await controller
                                                  .verifyAndStartRide();
                                            }),
                                      ),
                                      Gap(10.ss),
                                      Obx(
                                        () => controller.showCancle.isFalse
                                            ? const Offstage()
                                            : Column(
                                                children: [
                                                  Divider(
                                                    color:
                                                        AppColors.colordivider,
                                                  ),
                                                  Gap(20.ss),
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        );

      case MapState.NEGOTIATION_BOOKING_STATE:
        return Stack(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              decoration:
                  BoxDecoration(color: AppColors.colorBlack.withOpacity(0.3)),
            ),
            DraggableScrollableSheet(
              initialChildSize: controller.bottomSheetIntSize.value,
              minChildSize: controller.bottomSheetMinSize.value,
              maxChildSize: controller.bottomSheetMaxSize.value,
              expand: true,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.only(top: 20.0.ss),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 20.0.ss, left: 20.0.ss, right: 20.0.ss),
                      // height: size.height*3/4,
                      decoration: BoxDecoration(
                          color: AppColors.colorWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.ss),
                            topLeft: Radius.circular(30.ss),
                          )),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(10.ss),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 5.ss,
                                  width: 80.ss,
                                  color: AppColors.colorgrey,
                                ),
                              ],
                            ),
                            Gap(10.ss),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 20.0.ss),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: AppColors.colorWhite,
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.ss)),
                                            child: Image.network(
                                              controller.currentTrip.value
                                                      .customer?.profileImage ??
                                                  "",
                                              width: 38.ss,
                                              height: 38.ss,
                                              fit: BoxFit.fill,
                                            )),
                                      )),
                                  HorizontalGap(10.ss),
                                  Text(
                                    "${controller.currentTrip.value.customer?.firstName} ${controller.currentTrip.value.customer?.lastName}",
                                    style: CustomTextStyle(
                                        fontSize: 16.fss,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.titleColor),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${controller.currentTrip.value.currencySymbol} ${controller.currentTrip.value.price}",
                                    style: CustomTextStyle(
                                        fontSize: 16.fss,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.titleColor),
                                  )
                                ],
                              ),
                            ),
                            Gap(12.ss),
                            Divider(
                                color: AppColors.titleColor.withOpacity(0.5),
                                thickness: 0.3.ss),
                            Gap(16.ss),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 24.0.ss),
                              child: Text(
                                AppStrings.rideDetails.tr,
                                style: CustomTextStyle(
                                    fontSize: 16.fss,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.titleColor),
                              ),
                            ),
                            Gap(20.ss),
                            (controller.currentTrip.value?.isMultiStop ?? false)
                                ? ShareRideRouteWidget(
                                    source: Address(
                                        address: controller.currentTrip.value
                                                ?.sceLocation ??
                                            ""),
                                    destination: Address(
                                        address: controller.currentTrip.value
                                                ?.destLocation ??
                                            ""),
                                    multiStop:
                                        controller.currentTrip.value?.stoppages)
                                : RideRouteWidget(
                                    sourceAddress: controller
                                            .currentTrip.value?.sceLocation ??
                                        "",
                                    destinationAddress: controller
                                            .currentTrip.value?.destLocation ??
                                        "",
                                    sourceDistence:
                                        "${controller.currentTrip.value?.sceDistance?.distance?.text ?? ""} away (Pickup)",
                                    destinationDistecnce:
                                        "${controller.currentTrip.value?.destDistance?.distance?.text ?? ""} (Drop-off)",
                                  ),
                            Gap(20.ss),
                            Divider(
                                color: AppColors.titleColor.withOpacity(0.5),
                                thickness: 0.3.ss),
                            Center(
                                child: Text(
                              AppStrings.offerYourFare.tr,
                              style: CustomTextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.fss),
                            )),
                            Gap(10.ss),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 20.0.ss),
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonButton(
                                      label: "-5",
                                      buttonWidth: 55,
                                      fontWeight: FontWeight.w500,
                                      onClicked: () {
                                        controller.negotiationPriceSetting(
                                            controller.minimumPrice.value,
                                            controller.originalPrice.value,
                                            controller.maximumPrice.value,
                                            false);
                                      },
                                    ),
                                    Text(
                                      "${controller.currencySymbol} ${controller.originalPrice}",
                                      style: CustomTextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.fss),
                                    ),
                                    CommonButton(
                                      label: "+5",
                                      labelColor: AppColors.colorBlack,
                                      fontWeight: FontWeight.w500,
                                      borderColor: AppColors.buttonColor,
                                      solidColor: AppColors.colorWhite,
                                      onClicked: () {
                                        controller.negotiationPriceSetting(
                                            controller.minimumPrice.value,
                                            controller.originalPrice.value,
                                            controller.maximumPrice.value,
                                            true);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Gap(20.ss),
                            Obx(() => controller.isLimitReachedMaximum.value
                                ? Center(
                                    child: Text(
                                    "${AppStrings.maximumFare} ${controller.currencySymbol.value} ${controller.maximumPrice.value}",
                                    style: CustomTextStyle(
                                        color: AppColors.textRed,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.fss),
                                  ))
                                : const Offstage()),
                            Obx(() => controller.isLimitReachedMinimum.value
                                ? Center(
                                    child: Text(
                                    "${AppStrings.minimumFare} ${controller.currencySymbol.value} ${controller.minimumPrice.value}",
                                    style: CustomTextStyle(
                                        color: AppColors.textRed,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.fss),
                                  ))
                                : const Offstage()),
                            Gap(20.ss),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );

      case MapState.REQUEST_CUSTOMER_OTP_FOR_RIDE_START_STATE:
        return Obx(
          () => Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(color: AppColors.colorWhite),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Gap(30.ss),
                  SizedBox(
                    width: 283,
                    height: 68,
                    child: Text(
                        '${AppStrings.enter.tr}${controller.currentTrip.value.customer?.firstName} ${controller.currentTrip.value.customer?.lastName} ${AppStrings.verificationCode.tr}',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle(
                            color: AppColors.titleColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.fss)),
                  ),
                  Gap(20.ss),
                  Pinput(
                    androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                    controller: controller.pinControllerForRideStart,
                    length: 4,
                    defaultPinTheme: PinTheme(
                      width: 56.ss,
                      height: 56.ss,
                      textStyle: TextStyle(
                          fontSize: 20.fss,
                          color: AppColors.titleColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.colorgrey.withOpacity(1)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 56.ss,
                      height: 56.ss,
                      textStyle: TextStyle(
                          fontSize: 20.fss,
                          color: AppColors.titleColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.titleColor.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 56.ss,
                      height: 56.ss,
                      textStyle: TextStyle(
                          fontSize: 20.fss,
                          color: AppColors.titleColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        color: !controller.isRideOTPVerified.value
                            ? AppColors.colorlightgrey1
                            : AppColors.colorGreen,
                        border: Border.all(
                            color: AppColors.colorgrey.withOpacity(1)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) {
                      //print("PIN:${pin}");
                    },
                  ),
                  Gap(15.ss),
                  controller.otpValidationError.isEmpty
                      ? const Offstage()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outlined,
                              color: AppColors.textRed,
                            ),
                            HorizontalGap(5.ss),
                            Text(controller.otpValidationError.value,
                                style: CustomTextStyle(
                                  fontSize: 14.fss,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textRed,
                                ))
                          ],
                        ),
                  Gap(Get.height / 2),
                  controller.isLoading.isTrue
                      ? const Center(child: CircularProgressIndicator())
                      : CommonButton(
                          label: AppStrings.verifyRider.tr,
                          padding: EdgeInsets.symmetric(horizontal: 20.ss),
                          onClicked: () {
                            controller.verifyRiderWithOTP();
                          },
                        ),
                ],
              ),
            ),
          ),
        );

      case MapState.VERIFIED_OTP_AND_RIDE_START_STATE:
        return Obx(
          () => Stack(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration:
                    BoxDecoration(color: AppColors.colorBlack.withOpacity(0.3)),
              ),
              DraggableScrollableSheet(
                  //controller: DraggableScrollableController(),
                  initialChildSize: controller.bottomSheetIntSize.value,
                  minChildSize: controller.bottomSheetMinSize.value,
                  maxChildSize: controller.bottomSheetMaxSize.value,
                  expand: true,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.ss),
                        topLeft: Radius.circular(30.ss),
                      ),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 20.0.ss),
                              child: Container(
                                padding: EdgeInsets.all(15.ss),
                                height: 50.ss,
                                width: 50.ss,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white),
                                child:
                                    SvgPicture.asset("assets/icons/send.svg"),
                              ),
                            ),
                            Gap(20.ss),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(top: 5.0.ss),
                                decoration: BoxDecoration(
                                    color: AppColors.colorLoaderFill,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30.ss),
                                      topLeft: Radius.circular(30.ss),
                                    )),
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        AppStrings.rideInProgress.tr,
                                        style: CustomTextStyle(
                                            color: AppColors.colorWhite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14.fss),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 20.0.ss),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30.ss),
                                          topLeft: Radius.circular(30.ss),
                                        ),
                                        child: Container(
                                          // height: size.height*3/4,
                                          height: Get.height,
                                          decoration: BoxDecoration(
                                              color: AppColors.colorWhite,
                                              borderRadius: BorderRadius.only(
                                                topRight:
                                                    Radius.circular(30.ss),
                                                topLeft: Radius.circular(30.ss),
                                              )),
                                          child: SingleChildScrollView(
                                            controller: scrollController,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.ss,
                                                      vertical: 15.ss),
                                                  child: Column(
                                                    children: [
                                                      Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${controller.currentTrip.value.destDistance?.duration?.text}",
                                                              style: CustomTextStyle(
                                                                  color: AppColors
                                                                      .textBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      20.fss),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8.ss),
                                                              height: 6.ss,
                                                              width: 6.ss,
                                                              decoration: const BoxDecoration(
                                                                  color: AppColors
                                                                      .textBlack,
                                                                  shape: BoxShape
                                                                      .circle),
                                                            ),
                                                            Text(
                                                              "${(controller.currentTrip.value.destDistance?.duration?.value ?? 0) / 100} KM",
                                                              style: CustomTextStyle(
                                                                  color: AppColors
                                                                      .textBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      20.fss),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          "Dropping Off ${controller.currentTrip.value.customer?.firstName} ${controller.currentTrip.value.customer?.lastName}",
                                                          style: CustomTextStyle(
                                                              color: AppColors
                                                                  .textSubBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12.fss),
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: AppColors
                                                            .colordivider,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.ss,
                                                                vertical:
                                                                    10.ss),
                                                        child: Row(
                                                          children: [
                                                            CircleAvatar(
                                                              child: Image.network(controller
                                                                      .currentTrip
                                                                      .value
                                                                      ?.customer
                                                                      ?.profileImage ??
                                                                  ""),
                                                              backgroundColor:
                                                                  AppColors
                                                                      .colorGrey,
                                                              radius: 20.ss,
                                                            ),
                                                            HorizontalGap(
                                                                10.ss),
                                                            Expanded(
                                                              child: Text(
                                                                "${controller.currentTrip.value.customer?.firstName} ${controller.currentTrip.value.customer?.lastName}",
                                                                style: CustomTextStyle(
                                                                    color: AppColors
                                                                        .textBlack,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        16.fss),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: AppColors
                                                            .colordivider,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.ss,
                                                                vertical:
                                                                    10.ss),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              AppStrings
                                                                  .rideDetails,
                                                              style: CustomTextStyle(
                                                                  color: AppColors
                                                                      .textBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      16.fss),
                                                            ),
                                                            Gap(20.ss),
                                                            (controller
                                                                        .currentTrip
                                                                        .value
                                                                        ?.isMultiStop ??
                                                                    false)
                                                                ? ShareRideRouteWidget(
                                                                    enableDone:
                                                                        true,
                                                                    isLoading: controller
                                                                        .isLoading
                                                                        .value,
                                                                    onDone:
                                                                        (index) {
                                                                      controller.arrivedToStoppage(
                                                                          index:
                                                                              index);
                                                                    },
                                                                    source: Address(
                                                                        progressStatus:
                                                                            TripTimelineStatus
                                                                                .done,
                                                                        address:
                                                                            controller.currentTrip.value?.sceLocation ??
                                                                                ""),
                                                                    destination:
                                                                        Address(
                                                                            address: controller.currentTrip.value?.destLocation ??
                                                                                ""),
                                                                    multiStop: controller
                                                                        .currentTrip
                                                                        .value
                                                                        ?.stoppages)
                                                                : RideRouteWidget(
                                                                    sourceAddress: controller
                                                                            .currentTrip
                                                                            .value
                                                                            ?.sceLocation ??
                                                                        "",
                                                                    destinationAddress: controller
                                                                            .currentTrip
                                                                            .value
                                                                            ?.destLocation ??
                                                                        "",
                                                                    sourceDistence:
                                                                        "${controller.currentTrip.value.sceDistance?.distance?.text ?? ""} (Pickup)",
                                                                    destinationDistecnce:
                                                                        "${controller.currentTrip.value.destDistance?.distance?.text ?? ""} (Drop-off)",
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: AppColors
                                                            .colordivider,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    5.0.ss),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SvgPicture.asset(
                                                                      ImageUtils
                                                                          .shareIcon),
                                                                  HorizontalGap(
                                                                      5.ss),
                                                                  Text(
                                                                    AppStrings
                                                                        .shareTripStatus
                                                                        .tr,
                                                                    style: CustomTextStyle(
                                                                        fontSize: 12
                                                                            .fss,
                                                                        color: AppColors
                                                                            .titleColor,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 20.ss,
                                                              width: 1.ss,
                                                              decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .colordeepgrey),
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SvgPicture.asset(
                                                                      ImageUtils
                                                                          .shieldIcon),
                                                                  HorizontalGap(
                                                                      5.ss),
                                                                  Text(
                                                                    AppStrings
                                                                        .sosTools
                                                                        .tr,
                                                                    style: CustomTextStyle(
                                                                        fontSize: 12
                                                                            .fss,
                                                                        color: AppColors
                                                                            .textRed),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: AppColors
                                                            .colordivider,
                                                      ),
                                                      Gap(10),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        );

      case MapState.REASON_TO_CANCEL_RIDE:
        return Obx(
          () => Stack(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration:
                    BoxDecoration(color: AppColors.colorBlack.withOpacity(0.3)),
              ),
              DraggableScrollableSheet(
                  initialChildSize: controller.bottomSheetIntSize.value,
                  minChildSize: controller.bottomSheetMinSize.value,
                  maxChildSize: controller.bottomSheetMaxSize.value,
                  expand: true,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 20.0.ss),
                                    child: Container(
                                      // height: size.height*3/4,
                                      decoration: BoxDecoration(
                                          color: AppColors.colorWhite,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30.ss),
                                            topLeft: Radius.circular(30.ss),
                                          )),
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Gap(10.ss),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 5.ss,
                                                  width: 80.ss,
                                                  color: AppColors.colorgrey,
                                                ),
                                              ],
                                            ),
                                            Gap(12.ss),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.0.ss),
                                              child: Text(
                                                "${AppStrings.cancelRide}?",
                                                style: CustomTextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16.fss),
                                              ),
                                            ),
                                            Gap(16.ss),
                                            Divider(
                                                color: AppColors.titleColor
                                                    .withOpacity(0.5),
                                                thickness: 0.3.ss),
                                            Gap(20.ss),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.0.ss),
                                              child: Text(
                                                AppStrings
                                                    .whyDoYouWantToCancel.tr,
                                                style: CustomTextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14.fss),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.0.ss),
                                              child: Text(
                                                AppStrings.required.tr,
                                                style: CustomTextStyle(
                                                    color: AppColors.titleColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12.fss),
                                              ),
                                            ),
                                            Gap(20.ss),
                                            Obx(
                                              () => controller
                                                      .isOtherReasonsTapped
                                                      .value
                                                  ? const Offstage()
                                                  : ListView.builder(
                                                      controller:
                                                          scrollController,
                                                      shrinkWrap: true,
                                                      physics:
                                                          ClampingScrollPhysics(),
                                                      itemCount: controller
                                                          .cancelReasons
                                                          ?.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  top: BorderSide(
                                                                      color: AppColors
                                                                          .colordivider),
                                                                  bottom: BorderSide(
                                                                      color: AppColors
                                                                          .colordivider))),
                                                          child: InkWell(
                                                            onTap: () {
                                                              controller
                                                                  .cancellationReason
                                                                  .value = controller
                                                                      .cancelReasons![
                                                                          index]
                                                                      .reason ??
                                                                  "";
                                                              print(
                                                                  "Reason:${controller.cancellationReason.value}");
                                                              controller
                                                                      .mapState
                                                                      .value =
                                                                  MapState
                                                                      .WANT_TO_CANCEL_RIDE_STATE;
                                                            },
                                                            child: ListTile(
                                                                leading: Image.network(controller
                                                                        .cancelReasons![
                                                                            index]
                                                                        .icon ??
                                                                    ""),
                                                                title: Text(
                                                                  controller
                                                                          .cancelReasons![
                                                                              index]
                                                                          .reason ??
                                                                      "",
                                                                  style: CustomTextStyle(
                                                                      color: AppColors
                                                                          .titleColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14.fss),
                                                                )),
                                                          ),
                                                        );
                                                      }),
                                            ),
                                            Gap(12.ss),
                                            InkWell(
                                              onTap: () {
                                                controller.isOtherReasonsTapped
                                                    .value = true;
                                                controller.cancellationReason
                                                    .value = "";
                                              },
                                              child: ListTile(
                                                  leading: Icon(
                                                      Icons.more_horiz_rounded),
                                                  title: Text(
                                                    controller
                                                            .isOtherReasonsTapped
                                                            .isTrue
                                                        ? AppStrings
                                                            .writeYourReasonForCancellation
                                                            .tr
                                                        : AppStrings.other.tr,
                                                    style: CustomTextStyle(
                                                        color: AppColors
                                                            .titleColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14.fss),
                                                  )),
                                            ),
                                            Gap(12.ss),
                                            Obx(
                                              () => controller
                                                      .isOtherReasonsTapped
                                                      .value
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  24.0.ss),
                                                      child: Column(
                                                        children: [
                                                          CommonTextFormField(
                                                            controller: controller
                                                                .reasonForOtherCancellation,
                                                            margin: 0.0,
                                                            padding: 0.0,
                                                            decoration:
                                                                InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20))),
                                                              hintText:
                                                                  'Write a message',
                                                              filled: true,
                                                            ),
                                                            textInputAction:
                                                                TextInputAction
                                                                    .newline,
                                                            textInputType:
                                                                TextInputType
                                                                    .multiline,
                                                            maxLine: 3,
                                                          ),
                                                          Gap(10.ss),
                                                        ],
                                                      ),
                                                    )
                                                  : const Offstage(),
                                            ),
                                            Gap(20.ss)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        );

      case MapState.WANT_TO_CANCEL_RIDE_STATE:
        return Obx(
          () => DraggableScrollableSheet(
              initialChildSize: controller.bottomSheetIntSize.value,
              minChildSize: controller.bottomSheetMinSize.value,
              maxChildSize: controller.bottomSheetMaxSize.value,
              expand: true,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 20.0.ss),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  child: Container(
                                    // height: size.height*3/4,
                                    decoration: BoxDecoration(
                                        color: AppColors.colorWhite,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30.ss),
                                          topLeft: Radius.circular(30.ss),
                                        )),
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Gap(10.ss),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 5.ss,
                                                width: 80.ss,
                                                color: AppColors.colorgrey,
                                              ),
                                            ],
                                          ),
                                          Gap(12.ss),
                                          Center(
                                            child: Text(
                                              "${AppStrings.cancelRide}?",
                                              style: CustomTextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.fss),
                                            ),
                                          ),
                                          Gap(15.ss),
                                          Divider(
                                              color: AppColors.titleColor
                                                  .withOpacity(0.5),
                                              thickness: 0.3.ss),
                                          Gap(16.ss),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0.ss),
                                            child: Text(
                                              AppStrings
                                                  .areYouSureYouWantToCancel,
                                              style: CustomTextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.fss),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0.ss),
                                            child: Text(
                                              AppStrings.yourTripIsBeingOffered,
                                              style: CustomTextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.titleColor,
                                                  fontSize: 14.fss),
                                            ),
                                          ),
                                          Gap(18.ss),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        );

      case MapState.REACHED_TO_DESTINATION:
        return Obx(
          () => Stack(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration:
                    BoxDecoration(color: AppColors.colorBlack.withOpacity(0.3)),
              ),
              DraggableScrollableSheet(
                  initialChildSize: controller.bottomSheetIntSize.value,
                  minChildSize: controller.bottomSheetMinSize.value,
                  maxChildSize: controller.bottomSheetMaxSize.value,
                  expand: true,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20.0.ss),
                            child: Container(
                              padding: EdgeInsets.all(15.ss),
                              height: 50.ss,
                              width: 50.ss,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white),
                              child: SvgPicture.asset("assets/icons/send.svg"),
                            ),
                          ),
                          Gap(20.ss),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.ss),
                                topLeft: Radius.circular(30.ss),
                              ),
                              child: Container(
                                // height: size.height*3/4,
                                decoration: BoxDecoration(
                                    color: AppColors.colorWhite,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30.ss),
                                      topLeft: Radius.circular(30.ss),
                                    )),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.ss, vertical: 15.ss),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Container(
                                                height: 4.ss,
                                                width: 54.ss,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: AppColors
                                                        .bottomNavigationUnselectedColor),
                                              ),
                                            ),
                                            Gap(20),
                                            Text(
                                              AppStrings.reached.tr,
                                              style: CustomTextStyle(
                                                  fontSize: 20.fss,
                                                  color: AppColors.textBlack,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Gap(10),
                                            Text(
                                              "${AppStrings.droppingOff.tr} ${controller.currentTrip.value.customer!.firstName} ${controller.currentTrip.value.customer!.lastName}",
                                              style: CustomTextStyle(
                                                  fontSize: 12.fss,
                                                  color: AppColors.textBlack,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Gap(10),
                                            Divider(
                                              color: AppColors.colordivider,
                                            ),
                                            Obx(
                                              () => FlutterSwitch(
                                                  width: 335.ss,
                                                  height: 48.ss,
                                                  showOnOff: true,
                                                  centerText: true,
                                                  inactiveTextColor:
                                                      AppColors.colorWhite,
                                                  activeTextFontWeight:
                                                      FontWeight.w500,
                                                  inactiveTextFontWeight:
                                                      FontWeight.w500,
                                                  inactiveColor:
                                                      AppColors.buttonColor,
                                                  activeColor:
                                                      AppColors.buttonColor,
                                                  inactiveText: AppStrings
                                                      .completeRide.tr,
                                                  activeText: "",
                                                  inactiveIcon: Icon(
                                                    Icons.keyboard_arrow_right,
                                                  ),
                                                  activeIcon: Icon(
                                                    Icons.keyboard_arrow_left,
                                                  ),
                                                  valueFontSize: 25.0,
                                                  toggleSize: 40.0,
                                                  value: controller
                                                          .isArrivedAtDestination
                                                          .value
                                                      ? true
                                                      : false,
                                                  borderRadius: 12.0,
                                                  padding: 4.0,
                                                  onToggle: (value) async {
                                                    controller
                                                            .isArrivedAtDestination
                                                            .value =
                                                        !controller
                                                            .isArrivedAtDestination
                                                            .value;
                                                    await controller
                                                        .completeRide(
                                                            "completed");
                                                  }),
                                            ),
                                            Gap(10),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        );

      case MapState.LOADER_STATE:
        debugPrint("In loader state");
        return Obx(
          () => Stack(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration:
                    BoxDecoration(color: AppColors.colorBlack.withOpacity(0.3)),
              ),
              DraggableScrollableSheet(
                  controller: DraggableScrollableController(),
                  initialChildSize: controller.bottomSheetIntSize.value,
                  minChildSize: controller.bottomSheetMinSize.value,
                  maxChildSize: controller.bottomSheetMaxSize.value,
                  expand: true,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return LoaderWidget(
                      title: AppStrings.connectingYouToACustomer.tr,
                      subTitle: AppStrings.waitingForCustomerApproval.tr,
                      enableButton: false,
                      buttonText: AppStrings.cancelRide.tr,
                      onButtonClick: () {
                        // controller.rideStatus.value =
                        //     RideStatus.DRIVER_BID_ARRIVED;
                      },
                    );
                  }),
            ],
          ),
        );
      case MapState.TRIP_COMPLETE:
        debugPrint("In loader state");
        return Obx(
          () => Offstage(),
        );

      default:
        return Obx(
          () => DraggableScrollableSheet(
              controller: DraggableScrollableController(),
              initialChildSize: controller.bottomSheetIntSize.value,
              minChildSize: controller.bottomSheetMinSize.value,
              maxChildSize: controller.bottomSheetMaxSize.value,
              expand: true,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return LoaderWidget(
                  title: AppStrings.connectingYouToACustomer.tr,
                  subTitle: AppStrings.waitingForCustomerApproval.tr,
                  enableButton: false,
                  buttonText: AppStrings.cancelRide.tr,
                  onButtonClick: () {
                    // controller.rideStatus.value =
                    //     RideStatus.DRIVER_BID_ARRIVED;
                  },
                );
              }),
        );
    }
  }
}
