import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';
import '../../../core/common/common_button.dart';
import '../../../core/common/common_text_form_field.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/validator.dart';
import '../../../core/widgets/common_app_bar.dart';
import 'package:country_code_picker/country_code_picker.dart';

import '../../../core/widgets/gap.dart';
import '../../../core/widgets/title_text.dart';
import 'controller/forgot_password_controller.dart';

class SetNewPasswordPage extends GetView<ForgotPasswordController> {
  SetNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height / 12),
          //   preferredSize: Size.fromHeight(100.ss),
          child: CommonAppbar(
              title: AppStrings.newPassword.tr,
              isIconShow: true,
              onPressed: () {
                Get.back();
              }),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.ss, vertical: 20.ss),
          child: Obx(
            () => controller.isLoading.isTrue
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CommonButton(
                    onClicked: () {
                      controller.setPasssword();
                    },
                    label: AppStrings.next.tr,
                  ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.sizeOf(context).height - 50,
            child: Form(
              key: controller.setNewPasswordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(20.ss),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                    child: TitleText(context, AppStrings.password.tr),
                  ),
                  Gap(10.ss),
                  CommonTextFormField(
                    controller: controller.newPasswordController,
                    onValidator: Validator().validatePassword,
                  ),
                  Gap(20.ss),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                    child: TitleText(context, AppStrings.confirmPassword.tr),
                  ),
                  Gap(10.ss),
                  CommonTextFormField(
                    controller: controller.confirmPasswordController,
                    onValidator: (name) {
                      if (controller.confirmPasswordController.text == null ||
                          controller.confirmPasswordController.text.isEmpty) {
                        return 'Enter Confirm Password';
                      } else if (controller.confirmPasswordController.text !=
                          controller.newPasswordController.text) {
                        return "Confirm password doesn't match with Password";
                      } else {
                        return null;
                      }
                    },
                    // onValidator: Validator().validateConfirmPassword(controller.passwordController.text,controller.confirmPasswordController.text),
                  ),
                  Gap(10.ss),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.ss),
                    child: Text(
                      "Enter your Email for the verification. We will send 5 digits code to your number.",
                      style: CustomTextStyle(),
                    ),
                  ),
                  Gap(30.ss),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
