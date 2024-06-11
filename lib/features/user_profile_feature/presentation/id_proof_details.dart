import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import 'package:sizing/sizing.dart';

import 'controller/profile_controller.dart';

class IdProofDetailsPage extends GetView<ProfileController> {
  const IdProofDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: AppStrings.idProofDetails.tr,
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
                            AppStrings.letsFindYourIdProof.tr,
                            style: CustomTextStyle(
                                fontSize: 20.fss,
                                fontWeight: FontWeight.w700),
                          ),
                          Gap(10.ss),
                          Text(
                            "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
                            style: CustomTextStyle(
                                fontSize: 14.fss,
                                fontWeight: FontWeight.w400,
                                color: AppColors.colordeepgrey),
                          ),
                          Gap(30.ss),
                          Form(
                            key: controller.userIdProofFormKey,
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(
                                  context, AppStrings.idNumber.tr),
                              Gap(10.ss),
                              CommonTextFormField(
                                readOnly: controller.isLoading.value,
                                margin: 0,
                                padding: 0,
                                controller: controller.idNumberController,
                                isEnable: !controller.isLoading.value,
                                onValidator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.enterIdNumber.tr;
                                  } else {
                                    return null;
                                  }
                                },
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),],
                                hintText: AppStrings.enterIdNumber.tr,
                              ),
                              Gap(30.ss),
                              TitleText(context, AppStrings.dob.tr),
                              Gap(10.ss),
                              CommonTextFormField(
                                margin: 0,
                                padding: 0,
                                controller: controller.dobController,
                                isEnable: !controller.isLoading.value,
                                onValidator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.enterDob.tr;
                                  } else {
                                    return null;
                                  }
                                },
                                inputFormatters: [LowerCaseTextFormatter()],
                                hintText: AppStrings.enterDob.tr,
                                readOnly: true,
                                onTap: () async {
                                  DateTime today = DateTime.now();
                                  final eighteenYearBeforeDate = DateTime(today.year - 18, today.month, today.day);
                                  DateTime? date =
                                      await getDateTimeFromCalender(
                                          context: context,
                                          isFutureDateEnable: false,
                                          initialDate: eighteenYearBeforeDate,
                                          lastDate: eighteenYearBeforeDate);
                                  if (date != null) {
                                    String formattedDate =
                                        DateFormat('dd-MM-yyyy').format(date);
                                    controller.dobController.text =
                                        formattedDate;
                                  }
                                },
                              ),
                              Gap(30.ss),
                              Row(
                                children: [
                                  TitleText(
                                      context, AppStrings.uploadIDproof.tr),
                                  const Spacer(),
                                controller.temporaryIdImagePath.value.isNotEmpty?
                                GestureDetector(
                                    onTap: ()async{
                                      await modalBottomSheetMenu(context,
                                          (XFile? selectedImage) {
                                        controller.temporaryIdImageName
                                            .value = selectedImage!.name;
                                        controller.temporaryIdImagePath
                                            .value = selectedImage.path;
                                      });
                                    },
                                    child: TitleText(
                                        context, AppStrings.replace.tr,textColor: AppColors.iconColor),
                                  ):const Offstage(),
                                ],
                              ),
                              Gap(10.ss),
                              Center(
                                child:
                                DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(10.ss),
                                  color: AppColors.buttonColor,
                                  strokeWidth: 1,
                                  child:  controller.temporaryIdImagePath.value.isEmpty?Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.ss))),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          await modalBottomSheetMenu(context,
                                              (XFile? selectedImage) {
                                            controller.temporaryIdImageName
                                                .value = selectedImage!.name;
                                            controller.temporaryIdImagePath
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
                                                    .uploadYourIDProofFromYourDevice
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
                                      .temporaryIdImagePath.value),),
                                ),
                              )),


                              ),
                              Gap(MediaQuery.sizeOf(context).height / 6),
                              controller.isLoading.value
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(),
                                      ],
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.0.ss,
                                          vertical: 10.ss),
                                      child: CommonButton(
                                        label: AppStrings.save.tr,
                                        onClicked: () {
                                          controller.saveIdProof();
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
