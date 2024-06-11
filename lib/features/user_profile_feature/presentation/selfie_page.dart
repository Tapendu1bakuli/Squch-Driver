import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';

import '../../../core/common/common_button.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/gap.dart';
import 'controller/profile_controller.dart';

class SelfiePage extends GetView<ProfileController> {
  const SelfiePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: AppStrings.addSelfie.tr,
        isIconShow: true,
        onPressed: () {
          Get.back();
        },
      ),
      body: Obx(() => SafeArea(
            child: controller.isInitialLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.ss),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(10.ss),
                            Text(
                              AppStrings.uploadYourSelfie.tr,
                              style: CustomTextStyle(
                                  fontSize: 20.fss,
                                  fontWeight: FontWeight.w700),
                            ),
                            Gap(10.ss),
                            Text(
                              AppStrings.uploadYourSelfieMessage.tr,
                              style: CustomTextStyle(
                                  fontSize: 14.fss,
                                  fontWeight: FontWeight.w400,color: AppColors.colordeepgrey),
                            ),
                            Gap(30.ss),
                            Form(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gap(10.ss),

                                GestureDetector(
                                  onTap: () async {
                                    await modalBottomSheetMenu(context,isFront: true,
                                            (XFile? selectedImage) {
                                          controller.temporarySelfieImageName
                                              .value = selectedImage!.name;
                                          controller.temporarySelfieImagePath
                                              .value = selectedImage.path;
                                        });
                                  },
                                  child: controller.temporarySelfieImagePath.value.isEmpty?DottedBorder(
                                    padding: EdgeInsets.all(30.ss),
                                    borderType: BorderType.Circle,
                                    color: AppColors.buttonColor,
                                    strokeWidth: 1,
                                    child: Container(

                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50.ss, vertical: 50.ss),
                                      decoration: const BoxDecoration(

                                      shape: BoxShape.circle),
                                      child: Center(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 30.ss),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                  ImageUtils.camera,),
                                              Gap(10.ss),
                                              Text(
                                                AppStrings
                                                    .takeSelfie
                                                    .tr,
                                                style: CustomTextStyle(fontSize: 16.fss),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ):Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(150.ss),
                                      child: Container(
                                        width: 250.ss,
                                        height: 250.ss,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.ss),color: Colors.red),
                                        child: Image.file(fit: BoxFit.fitWidth,File(controller
                                            .temporarySelfieImagePath.value)),
                                      ),
                                    ),
                                  ),
                                ),
                                Gap(20.ss),
                              ],
                            ))
                          ],
                        ),
                      ),
                      controller.isLoading.value
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child:
                                  const Center(child: CircularProgressIndicator()))
                          : const Offstage()
                    ],
                  )),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: controller.isLoading.value
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            )
          : Obx(() =>
              Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.0.ss, vertical: 10.ss),
              child: ListView(
                shrinkWrap: true,
                children: [
                  controller.temporarySelfieImagePath.value.isEmpty?
                  const Offstage():
                  CommonButton(
                    solidColor: AppColors.colorbuttongrey,
                    borderColor: AppColors.colorbuttongrey,
                    labelColor: AppColors.titleColor,
                    label: AppStrings.retake.tr,
                    onClicked: () async {
                      await modalBottomSheetMenu(context,isFront: true,
                          (XFile? selectedImage) {
                        controller.temporarySelfieImageName
                            .value = selectedImage!.name;
                        controller.temporarySelfieImagePath
                            .value = selectedImage.path;
                      });
                    },
                  ),
                  Gap(10.ss),
                  CommonButton(
                    label: AppStrings.submit.tr,
                    onClicked: () {
                      controller.updateSelfie();
                    },
                  ),
                ],
              ),
            ),)
    );
  }

}
