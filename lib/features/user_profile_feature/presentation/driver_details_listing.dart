import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:squch_driver/core/widgets/horizontal_gap.dart';
import 'package:squch_driver/features/user_profile_feature/presentation/controller/profile_controller.dart';
import '../../../core/common/common_button.dart';
import '../../../core/service/page_route_service/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/gap.dart';
import '../../../core/widgets/title_text.dart';
import 'package:sizing/sizing.dart';

class DriverDetailsListingPage extends GetView<ProfileController> {
  const DriverDetailsListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: AppStrings.driverDetails.tr,
        isIconShow: false,
        // onPressed: () {
        //   Get.back();
        // },
      ),
      body: Obx(() => SafeArea(
            child: controller.isInitialLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.ss),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10.ss),
                  Text(
                    AppStrings.hiWelcomeBackWithExclamatory.tr,
                    style: CustomTextStyle(
                        fontSize: 20.fss, fontWeight: FontWeight.w700),
                  ),
                  Gap(10.ss),
                  Text(
                    AppStrings.setupAccountTitle.tr,
                    style: CustomTextStyle(
                        fontSize: 14.fss,
                        fontWeight: FontWeight.w400,
                        color: AppColors.colordeepgrey),
                  ),
                  Gap(20.ss),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.driverDetailsList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            controller.clearForm();
                            if (index == 1 &&
                                (controller.driverDetailsList[index].status ==
                                        "pending" ||
                                    controller.driverDetailsList[index].status ==
                                        "rejected")) {
                              Get.toNamed(Routes.ID_PROOF_DETAILS);
                            } else if (index == 2 &&
                                (controller.driverDetailsList[index].status ==
                                        "pending" ||
                                    controller.driverDetailsList[index].status ==
                                        "rejected")) {
                              controller.getVehicleCompanyList();
                              Get.toNamed(Routes.CAR_DETAILS);
                            } else if (index == 3 &&
                                (controller.driverDetailsList[index].status ==
                                        "pending" ||
                                    controller.driverDetailsList[index].status ==
                                        "rejected")) {
                              Get.toNamed(Routes.DRIVING_LICENCE_DETAILS);
                            } else if (index == 4 &&
                                (controller.driverDetailsList[index].status ==
                                        "pending" ||
                                    controller
                                            .driverDetailsList[index].status ==
                                        "rejected")) {
                              Get.toNamed(Routes.SELFIE_PAGE);
                            } else if (index == 5 &&
                                (controller.driverDetailsList[index].status ==
                                        "pending" ||
                                    controller
                                            .driverDetailsList[index].status ==
                                        "rejected")) {
                              Get.toNamed(Routes.INSURANCE_DETAILS);
                            } else if (index == 6 &&
                                (controller.driverDetailsList[index].status ==
                                        "pending" ||
                                    controller
                                            .driverDetailsList[index].status ==
                                        "rejected")) {
                              controller.getBankNames();
                              Get.toNamed(Routes.PAYOUT_BANK_DETAILS);
                            }
                          },
                          child: driverDetailsItem(
                              context,
                              controller,
                              controller.driverDetailsList[index].image ?? "",
                              controller.driverDetailsList[index].title ?? "",
                              index));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:  EdgeInsets.only(left: 54.0.ss),
                        child: const Divider(
                          color: AppColors.bottomDividerColor,
                        ),
                      );
                    },
                  ),
                  Gap(MediaQuery.sizeOf(context).height / 12),
                  controller.isLoading.value
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.0.ss, vertical: 10.ss),
                          child: CommonButton(
                            solidColor: controller.logedinData?.user!
                                        .driverDocument!.documentStatus ==
                                    "rejected"
                                ? AppColors.colorLightGrey
                                : AppColors.buttonColor,
                            label: AppStrings.next.tr,
                            onClicked: () {
                              debugPrint(controller.logedinData!.user!
                                  .driverDocument!.documentStatus);
                              if (controller.logedinData!.user!.driverDocument!
                                      .documentStatus ==
                                  "pending") {
                                Get.offAllNamed(Routes.DASHBOARD);
                              } else if (controller.logedinData!.user!
                                          .driverDocument!.documentStatus ==
                                      "pending" ||
                                  controller.logedinData!.user!.driverDocument!
                                          .documentStatus ==
                                      "rejected") {
                              } else {
                                Get.offAllNamed(Routes.DASHBOARD);
                              }
                            },
                          ),
                        ),
                ],
              ),
            )),
          )),
    );
  }

  Widget driverDetailsItem(BuildContext context, ProfileController controller,
      String image, String title, int position) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.ss),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.ss, vertical: 10.ss),
          decoration: BoxDecoration(
              color: AppColors.iconColor.withOpacity(0.08),
              borderRadius: BorderRadius.all(Radius.circular(10.ss))),
          child: SvgPicture.asset(image),
        ),
        title: TitleText(context, title),
        trailing: controller.driverDetailsList[position].status ==
            "pending"
            ? Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10.ss, vertical: 5.ss),
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(5.ss)),
              color: AppColors.colorRed.withOpacity(0.1)),
          child: Text(
            controller.driverDetailsList[position].status
                .toString(),
            style: CustomTextStyle(
                color: AppColors.colorRed,
                fontWeight: FontWeight.w500),
          ),
        )
            : controller.driverDetailsList[position].status ==
            "inreview"
            ? Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10.ss, vertical: 5.ss),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5.ss)),
              color: AppColors.colorYollow
                  .withOpacity(0.1)),
          child: Text(
            controller
                .driverDetailsList[position].status
                .toString(),
            style: CustomTextStyle(
                color: AppColors.colorYollow,
                fontWeight: FontWeight.w500),
          ),
        )
            : controller.driverDetailsList[position]
            .status ==
            "rejected"
            ? Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10.ss, vertical: 5.ss),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5.ss)),
              color: AppColors.colorRed
                  .withOpacity(0.1)),
          child: Text(
            controller.driverDetailsList[position]
                .status
                .toString(),
            style: CustomTextStyle(
                color: AppColors.colorRed,
                fontWeight: FontWeight.w500),
          ),
        )
            : SvgPicture.asset(ImageUtils.verified),
      ),
    );
  }
}
