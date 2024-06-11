import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pinput/pinput.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/utils/app_strings.dart';
import 'package:squch_driver/core/widgets/common_app_bar.dart';
import 'package:squch_driver/core/widgets/gap.dart';
import 'package:squch_driver/core/widgets/horizontal_gap.dart';
import 'package:squch_driver/features/dashboard_feature/presentation/controller/map_state.dart';
import 'package:squch_driver/features/dashboard_feature/widget/share_ride_route_widget.dart';
import 'package:squch_driver/features/map_page_feature/data/models/address_model.dart';

import '../../../common/widget/flutter_switch.dart';
import '../../../core/common/common_button.dart';
import '../../../core/common/common_text_form_field.dart';
import '../../../core/service/page_route_service/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/drawer_home.dart';
import '../../../core/widgets/linear_percent_indicator_widget.dart';
import '../../../core/widgets/loader_widget.dart';
import '../../../core/widgets/new_booking_card.dart';
import '../../map_page_feature/presentation/map_page.dart';
import '../widget/dragable_scroll_sheet_widget.dart';
import 'controller/dashboard_controller.dart';

class DashBoardPage extends GetView<DashboardController> {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: 310.ss,
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
          ),
          elevation: 2,
          child: MainDrawerWidget(),
        ),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImageUtils.appbarTopLogo,
              height: 20.53.ss,
              width: 21.73.ss,
            ),
            Container(
              width: 8.ss,
            ),
            Text(
              AppStrings.appName.tr,
              style: CustomTextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              //Get.toNamed(Routes.RIDE_SUMMARY);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: SvgPicture.asset(
                      ImageUtils.notificationOutline,
                      width: 24.ss,
                      height: 24.ss,
                    ),
                  ),
                  Positioned(
                    right: 3.ss,
                    top: 15.ss,
                    child: Container(
                      padding: EdgeInsets.all(1.ss),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6.ss),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 9.ss,
                        minHeight: 9.ss,
                      ),
                      /*child: Text(
                        '${controller.counter}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.fss,
                        ),
                        textAlign: TextAlign.center,
                      ),*/
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        switch (controller.mapState.value) {
          case MapState.VERIFIED_OTP_AND_RIDE_START_STATE:
            return InkWell(
              onTap: () {
                controller.manageMapState(MapState.REACHED_TO_DESTINATION);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.ss),
                child: Text(
                  AppStrings.endRide,
                  textAlign: TextAlign.center,
                  style: CustomTextStyle(
                      color: AppColors.textRed,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.fss),
                ),
              ),
            );
          case MapState.REASON_TO_CANCEL_RIDE:
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10.ss, horizontal: 20.ss),
              child: ListView(
                shrinkWrap: true,
                children: [
                  controller.isOtherReasonsTapped.isTrue
                      ? CommonButton(
                          label: AppStrings.cancelRequest,
                          solidColor: AppColors.buttonColor,
                          labelColor: AppColors.colorWhite,
                          onClicked: () {
                            controller.isLoading.value = false;
                            controller.manageMapState(
                                MapState.WANT_TO_CANCEL_RIDE_STATE);
                          },
                        )
                      : Offstage(),
                  InkWell(
                    onTap: () {
                      Get.back();
                      controller.manageMapState(MapState.ACCEPT_BOOKING_STATE);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.ss),
                      child: Text(
                        AppStrings.keepMyRide,
                        textAlign: TextAlign.center,
                        style: CustomTextStyle(
                            color: AppColors.textRed,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.fss),
                      ),
                    ),
                  ),
                ],
              ),
            );
          case MapState.WANT_TO_CANCEL_RIDE_STATE:
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10.ss, horizontal: 20.ss),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(10.ss),
                  controller.isLoading.isTrue
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.ss),
                          child: CommonButton(
                            borderRadius: 12.ss,
                            label: AppStrings.yesCancel,
                            labelColor: AppColors.textBlack,
                            solidColor: AppColors.colorbuttongrey,
                            onClicked: () {
                              if (controller.isOtherReasonsTapped.isTrue &&
                                  controller.reasonForOtherCancellation.text
                                      .isEmpty) {
                                showFailureSnackbar(
                                    "Oops!", AppStrings.otherReasonMsg.tr);
                              } else
                                controller.cancelRide(controller
                                        .isOtherReasonsTapped.value
                                    ? controller.reasonForOtherCancellation.text
                                    : controller.cancellationReason.value);
                            },
                          ),
                        ),
                  Gap(5.ss),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.ss),
                    child: CommonButton(
                      borderRadius: 12.ss,
                      label: AppStrings.keepMyRide,
                      onClicked: () {
                        if (controller.isDriverArrivedToThePickupPoint.isTrue) {
                          controller
                              .manageMapState(MapState.PICKUP_BOOKING_STATE);
                          controller.pickupTimerInSec.value = 0;
                          controller.isDriverArrivedToThePickupPoint.value =
                              false;
                        } else {
                          controller
                              .manageMapState(MapState.ACCEPT_BOOKING_STATE);
                        }
                        controller.update();
                      },
                    ),
                  ),
                ],
              ),
            );
          case MapState.NEGOTIATION_BOOKING_STATE:
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10.ss, horizontal: 20.ss),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(10.ss),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.ss),
                    child: CommonButton(
                      buttonWidth: 161.ss,
                      borderRadius: 12.ss,
                      label: AppStrings.skip,
                      labelColor: AppColors.textBlack,
                      solidColor: AppColors.colorbuttongrey,
                      onClicked: () {
                        controller.onNegotationSkip(
                            trips: controller.currentTrip.value);
                      },
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.ss),
                    child: controller.isLimitReachedMaximum.isTrue ||
                            controller.isLimitReachedMinimum.isTrue
                        ? CommonButton(
                            solidColor: AppColors.textRed,
                            buttonWidth: 161.ss,
                            borderRadius: 12.ss,
                            label: AppStrings.send,
                            onClicked: null,
                          )
                        : CommonButton(
                            buttonWidth: 161.ss,
                            borderRadius: 12.ss,
                            label: AppStrings.send,
                            onClicked: () {
                              controller.currentTrip.value.price =
                                  controller.originalPrice.toInt();
                              controller.onAcceptTrip(
                                  trips: controller.currentTrip.value);
                            },
                          ),
                  ),
                ],
              ),
            );
          case MapState.ACCEPT_BOOKING_STATE:
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Wrap(
                children: [
                  Gap(10.ss),
                  CommonButton(
                    padding: EdgeInsets.symmetric(horizontal: 20.ss),
                    buttonWidth: MediaQuery.sizeOf(context).width,
                    fontSize: 15.fss,
                    onClicked: () {
                      controller.arrivedPickupPoint();
                    },
                    label: AppStrings.arrivedAtPickupPoint.tr,
                  ),
                  Gap(10.ss),
                  Divider(
                    color: AppColors.colordivider,
                  ),
                  Gap(20.ss),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        controller.findReasonToCancelRide();
                      },
                      child: Center(
                          child: controller.isLoading.isTrue
                              ? const CircularProgressIndicator()
                              : Text(
                                  AppStrings.cancelRide,
                                  style: CustomTextStyle(
                                      color: AppColors.textRed,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.fss),
                                )),
                    ),
                  ),
                ],
              ),
            );
          default:
            return const Offstage();
        }
      }),
      /*body: TripRouteWidget(
          source: controller.source,
          destination: controller.destination,
          multiStop: controller.multiStop),*/

      body: Obx(
          () => Stack(
            children: [
              MapPage(),
              Visibility(
                visible: controller.mapState == MapState.INITIAL_STATE,
                child: Positioned(
                    top: 0.ss,
                    left: 0.ss,
                    right: 0.ss,
                    child: Obx(
                      () => Container(
                        color: controller.isDocumentsVerified.isFalse
                            ? AppColors.colorYollow
                            : AppColors.iconColor,
                        child: Center(
                          child: ListTile(
                            leading: SvgPicture.asset(
                              controller.isDocumentsVerified.isFalse
                                  ? ImageUtils.driverOffline
                                  : controller.isOnline.isFalse
                                      ? ImageUtils.driverOffline
                                      : ImageUtils.driverOnline,
                            ),
                            title: Text(
                              controller.isDocumentsVerified.isFalse
                                  ? AppStrings.driverDocumentsUnderVerification
                                  : controller.isOnline.isFalse
                                      ? AppStrings.driverOfflineTitle.tr
                                      : AppStrings.driverOnlineTitle.tr,
                              textAlign: TextAlign.left,
                              style: CustomTextStyle(
                                color: Colors.white,
                                fontSize: 16.fss,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              controller.isDocumentsVerified.isFalse
                                  ? AppStrings
                                      .driverDocumentsUnderVerificationMsg
                                  : controller.isOnline.isFalse
                                      ? AppStrings.driverOfflineSubTitle.tr
                                      : AppStrings.driverOnlineSubTitle.tr,
                              textAlign: TextAlign.left,
                              style: CustomTextStyle(
                                color: Colors.white,
                                fontSize: 12.fss,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
              Visibility(
                visible: controller.isDocumentsVerified.value,
                child: Positioned(
                    bottom: 78.ss,
                    left: 0.ss,
                    right: 0.ss,
                    child: Obx(
                      () => FlutterSwitch(
                        //width: 100.ss,
                        showOnOff: true,
                        disabled: controller.isLoading.isTrue,
                        activeTextColor: AppColors.colorWhite,
                        inactiveTextColor: AppColors.colorWhite,
                        activeColor: AppColors.switcherOnlineColor,
                        activeText: AppStrings.online.tr,
                        activeTextFontWeight: FontWeight.w500,
                        inactiveTextFontWeight: FontWeight.w500,
                        inactiveText: AppStrings.offline.tr,
                        value: controller.isOnline.isTrue,
                        onToggle: (val) {
                          controller.changeOnlineStatus(status: val);
                        },
                      ),
                    )),
              ),
              DragableScrollSheetWidget(),
            ],
          ),
        )
    );
  }
}
