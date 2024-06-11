import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../../core/common/common_button.dart';
import '../../../core/service/page_route_service/routes.dart';
import '../../../core/shared_pref/shared_pref.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import 'package:sizing/sizing.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/widgets/gap.dart';
import '../../../core/widgets/title_text.dart';


import 'controller/introduction_controller.dart';

class IntroductionPage extends GetView<IntroductionController> {
  IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: controller.pageList,
        scrollDirection: Axis.horizontal,
        controller: controller.pageController,
        onPageChanged: (int page) {},
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
          padding: EdgeInsets.all(20.ss),
          child: Obx(
            () {
              return controller.index == controller.pageList.length - 1
                  ? CommonButton(
                      label: AppStrings.enrollToday.tr,
                      onClicked: () {
                        Get.offAllNamed(Routes.LANDING);
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: controller.onSkip,
                          child: Text(
                            "Skip",
                            style: CustomTextStyle(
                                color: AppColors.colorWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.fss),
                          ),
                        ),
                        InkWell(
                          onTap: controller.tapNext,
                          child: Container(
                            width: 60.0.ss,
                            height: 60.0.ss,
                            decoration: new BoxDecoration(
                              color: AppColors.buttonColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.colorWhite,
                              size: 24.ss,
                            ),
                          ),
                        ),
                      ],
                    );
            },
          )),
    );
  }
}
