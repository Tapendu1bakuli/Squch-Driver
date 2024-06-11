import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/common/common_button.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/gap.dart';
import '../../../core/widgets/title_text.dart';
import 'package:sizing/sizing.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';

import 'controller/forgot_password_controller.dart';
import 'controller/registration_controller.dart';
import 'set_new_password_page.dart';

class VerifyForgetPasswordOtp extends GetView<ForgotPasswordController> {
  const VerifyForgetPasswordOtp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final defaultPinTheme = PinTheme(
      width: 56.ss,
      height: 56.ss,
      textStyle: TextStyle(
          fontSize: 20.fss,
          color: AppColors.titleColor.withOpacity(0.7),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorgrey.withOpacity(1)),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.titleColor.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: !controller.isMobileVerified.value
            ? AppColors.colorlightgrey1
            : AppColors.colorGreen,
      ),
    );
    final submittedEmailPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: !controller.isEmailVerified.value
            ? AppColors.colorlightgrey1
            : AppColors.colorGreen,
      ),
    );
    return Container();
    /*return SafeArea(
      top: true,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height / 12),
          child: CommonAppbar(
              title: AppStrings.VerifywithOTP.tr,
              isIconShow: true,
              onPressed: () {}),
        ),
        body: Obx(() => SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.ss),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(20.ss),
                    TitleText(context, AppStrings.VerifyPhoneNumber.tr),
                    Gap(10.ss),
                    Pinput(
                      enabled: !controller.isMobileVerified.value,
                      androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                      controller: controller.pinController,
                      length: 5,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      validator: (s) {
                        return (s == null || s.isEmpty)
                            ? "Enter Otp"
                            : s.length < 5
                                ? "Enter valid otp"
                                : null;
                      },
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) => controller.verifyMobileOtp(),
                    ),
                    Gap(10.ss),
                    Visibility(
                      visible: !controller.isMobileVerified.value,
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            controller.resendOTP("MOBILE");
                          },
                          child: RichText(
                            text: TextSpan(
                              text: AppStrings.DidntReceiveIt.tr,
                              style: CustomTextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                    text: AppStrings.ResendOTP.tr,
                                    style: CustomTextStyle(
                                        color: AppColors.buttonColor,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.isMobileVerified.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.ss),
                            child: Divider(
                                color: AppColors.colorgrey, thickness: 1.ss),
                          ),
                          TitleText(context, AppStrings.VerifyEmailId.tr),
                          Gap(10.ss),
                          Pinput(
                            enabled: !controller.isEmailVerified.value,
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.none,
                            controller: controller.emailPinController,
                            length: 5,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedEmailPinTheme,
                            validator: (s) {
                              return (s == null || s.isEmpty)
                                  ? "Enter Otp"
                                  : s.length < 5
                                      ? "Enter valid otp"
                                      : null;
                            },
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            showCursor: true,
                            onCompleted: (pin) => controller.verifyEmailOtp(),
                          ),
                          Gap(10.ss),
                          Visibility(
                            visible: !controller.isEmailVerified.value,
                            child: Container(
                              child: InkWell(
                                onTap: (() {
                                  controller.resendOTP("EMAIL");
                                }),
                                child: RichText(
                                  text: TextSpan(
                                    text: AppStrings.DidntReceiveIt.tr,
                                    style: CustomTextStyle(color: Colors.grey),
                                    children: [
                                      TextSpan(
                                          text: AppStrings.ResendOTP.tr,
                                          style: CustomTextStyle(
                                              color: AppColors.buttonColor,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(60.ss),
                    controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CommonButton(
                            label: AppStrings.VerifyOTP.tr,
                            onClicked: () {
                                Get.toNamed(Routes.SETUP_NEW_PASSWORD);
                            },
                          ),
                    Gap(20.ss)
                  ],
                ),
              ),
            )),
      ),
    );*/
  }
}
