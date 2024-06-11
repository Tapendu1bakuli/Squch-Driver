import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';

import '../../common/widget/introWidget.dart';
import '../../core/common/common_button.dart';
import '../../core/service/page_route_service/routes.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_strings.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image_utils.dart';
import '../../core/widgets/gap.dart';
import 'presentation/controller/introduction_controller.dart';

class LandingScreen extends GetView<IntroductionController> {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20.ss),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonButton(
              label: AppStrings.signUp.tr,
              onClicked: () {
                Get.toNamed(Routes.CHOOSECOUNTRY);
              },
            ),
            Gap(20),
            CommonButton(
              borderColor: AppColors.colorWhite,
              solidColor: AppColors.colorBlack,
              label: AppStrings.signIn.tr,
              onClicked: () {
                controller.sharedPref.setLoggedin(true);
                Get.offNamed(Routes.LOGIN);
              },
            )
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImageUtils.landing),
                    fit: BoxFit.fitWidth)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(20.ss),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.ss),
                    ),
                  ),
                  height: MediaQuery.sizeOf(context).height / 2.5,
                  child: Stack(
                    children: [
                      Positioned(
                          top: 50.ss,
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 10,
                                ),
                                SvgPicture.asset(
                                  ImageUtils.splashIcon,
                                  color: AppColors.colorWhite,
                                ),
                                Container(
                                  width: 10,
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.3),
                    Colors.black,
                    Colors.black
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 163.ss,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(20.ss),
              child: Column(
                children: [
                  Text(
                    AppStrings.landingTitle,
                    textAlign: TextAlign.center,
                    style: CustomTextStyle(
                        color: AppColors.colorWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 24.fss),
                    overflow: TextOverflow.clip,
                  ),
                  Gap(10.ss),
                  Text(
                    AppStrings.landingSubTitle,
                    textAlign: TextAlign.center,
                    style: CustomTextStyle(
                        color: AppColors.colorWhite,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.fss),
                    overflow: TextOverflow.clip,
                  ),
                  Gap(20.ss),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
