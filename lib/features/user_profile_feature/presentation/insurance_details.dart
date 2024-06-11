import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizing/sizing.dart';

import '../../../core/common/common_button.dart';
import '../../../core/common/common_text_form_field.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/gap.dart';
import '../../../core/widgets/title_text.dart';
import 'controller/profile_controller.dart';

class InsuranceDetailsPage extends GetView<ProfileController> {
  const InsuranceDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: AppStrings.insuranceDetails.tr,
        isIconShow: true,
        onPressed: () {
          Get.back();
        },
      ),
      body: Obx(() => SafeArea(
            child: controller.isInitialLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.ss),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(10.ss),
                          Text(
                            AppStrings.vehicleInsurancePhoto.tr,
                            style: CustomTextStyle(
                                fontSize: 20.fss,
                                fontWeight: FontWeight.w700),
                          ),
                          Gap(10.ss),
                          Text(
                            AppStrings.vehicleInsuranceDetailsMessage.tr,
                            style: CustomTextStyle(
                                fontSize: 14.fss,
                                fontWeight: FontWeight.w400,color: AppColors.colordeepgrey),
                          ),
                          Gap(30.ss),
                          Form(
                            key: controller.userInsuranceFormKey,
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(context,
                                  AppStrings.vehicleInsuranceNumber.tr),
                              Gap(10.ss),
                              CommonTextFormField(
                                readOnly: controller.isLoading.value,
                                hintText: AppStrings.enterVehicleInsuranceNumber.tr,
                                margin: 0,
                                padding: 0,
                                controller:
                                    controller.insuranceNumberController,
                                onValidator: (value){
                                  if(value == null || value.isEmpty){
                                    return AppStrings.enterVehicleInsuranceNumber.tr;
                                  }else {
                                    return null;
                                  }
                                },
                              ),
                              Gap(30.ss),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TitleText(
                                      context,
                                      AppStrings
                                          .uploadVehicleInsuranceNumber.tr),
                                  Visibility(
                                    visible: controller.temporaryInsuranceImagePath.value.isNotEmpty,
                                    child: InkWell(
                                        onTap: ()async{
                                          await modalBottomSheetMenu(context,
                                                  (XFile? selectedImage) {
                                                controller.temporaryInsuranceImageName
                                                    .value = selectedImage!.name;
                                                controller.temporaryInsuranceImagePath
                                                    .value = selectedImage.path;
                                              });
                                        },
                                        child: TitleText(context, AppStrings.replace.tr,textColor: AppColors.buttonColor)),
                                  ),
                                ],
                              ),
                              Gap(10.ss),

                              DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(10.ss),
                                color: AppColors.buttonColor,
                                strokeWidth: 1,
                                child:  controller.temporaryInsuranceImagePath.value.isEmpty?
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.ss))),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: ()async {
                                        await modalBottomSheetMenu(context,
                                            (XFile? selectedImage) {
                                          controller.temporaryInsuranceImageName
                                              .value = selectedImage!.name;
                                          controller.temporaryInsuranceImagePath
                                              .value = selectedImage.path;
                                        });
                                      },
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
                                                ImageUtils.upload),
                                            Gap(10.ss),
                                            Text(
                                              AppStrings
                                                  .uploadVehicleInsuranceNumber
                                                  .tr,
                                              style: CustomTextStyle(),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                      : Container(
                                  width: MediaQuery.sizeOf(context).width,
                            height: 189.ss,
                            padding: EdgeInsets.symmetric(horizontal: 0.ss),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.ss))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.ss)),
                              child: Image.file(fit: BoxFit.fitWidth,
                                File(controller
                                    .temporaryInsuranceImagePath.value),),
                            ),
                          ),
                              ),
                              Gap(MediaQuery.sizeOf(context).height/5),
                              controller.isLoading.value
                                  ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              )
                                  : Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 0.0.ss, vertical: 10.ss),
                                child: CommonButton(
                                  label: AppStrings.submit.tr,
                                  onClicked: () {
                                    controller.saveInsuranceDetails();
                                  },
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    )),
          )),

    );
  }

}
