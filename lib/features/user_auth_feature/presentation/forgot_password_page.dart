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

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  const ForgotPasswordPage({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppbar(
            title: AppStrings.forgotPassword.tr,
            isIconShow: true,
            onPressed: () {
              Get.back();
            }),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.ss, vertical: 20.ss),
          child: Obx(
            () => controller.isLoading.isTrue
                ? Container(child: Center(child: CircularProgressIndicator()))
                : CommonButton(
                    onClicked: () {
                      controller.forgotPasssword();
                    },
                    label: AppStrings.next.tr,
                  ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.sizeOf(context).height - 50,
            child: Form(
              key: controller.forgotPasswordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => controller.isPhone.isTrue
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(20.ss),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.0.ss),
                                child:
                                    TitleText(context, AppStrings.phoneNumber),
                              ),
                              Gap(20.ss),

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.ss),

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10.ss),),
                                    border: Border.all(width: controller.isValidPhoneNo.value == false? 1.ss: 0.5.ss,color:  controller.isValidPhoneNo.value == false?Colors.red: Colors.black ,)
                                ),
                                child: Row(
                                  children: [
                                    //CommonTextFormField(width: MediaQuery.sizeOf(context).width/4,),
                                    Container(width: MediaQuery.sizeOf(context).width/4,
                                      child: CountryCodePicker(
                                        onChanged: (newValue){
                                      //    controller.selectedCountryCode.value = newValue.dialCode??"+91";
                                        },
                                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                        initialSelection: controller.selectedCountryCode.value,
                                        favorite: ['+91','IN'],
                                        // optional. Shows only country name and flag
                                        showCountryOnly: false,
                                        // optional. Shows only country name and flag when popup is closed.
                                        showOnlyCountryWhenClosed: false,
                                        // optional. aligns the flag and the Text left
                                        alignLeft: false,
                                      ),
                                    ),

                                    Container(height: 30.ss,width: 0.5.ss,color: Colors.black ,),
                                    Flexible(child: CommonTextFormField(
                                      controller: controller.emailOrPhoneController,
                                      textInputType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      maxLength: 10,
                                      //  onValidator: Validator().validateMobile,
                                      onValueChanged: (value){
                                        controller.phoneValidationMsg.value = Validator().validateMobile(value)??"";
                                        if(Validator().validateMobile(value)!= null){
                                          controller.isValidPhoneNo.value = false;
                                        }else controller.isValidPhoneNo.value = true;
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          counterText: ""
                                      ),

                                    )),
                                  ],
                                ),
                              ),

                              Visibility(visible:  controller.isPhone.value && !controller.isValidPhoneNo.value && controller.phoneValidationMsg.value.isNotEmpty,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 20.0.ss,vertical: 5.ss),
                                  child: Text(
                                    controller.phoneValidationMsg.value,style: CustomTextStyle(color: Colors.red),
                                  ),
                                ),),
                              Gap(20.ss),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.0.ss),
                                child:
                                    TitleText(context, AppStrings.emailAddress),
                              ),
                              Gap(20.ss),
                              CommonTextFormField(
                                controller: controller.emailOrPhoneController,
                                hintText: "Enter email id",
                                onValidator: Validator().validateEmail,
                                inputFormatters: [LowerCaseTextFormatter()],
                              ),
                              Gap(10.ss),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.0.ss),
                                child: Text(
                                  "Enter your Email for the verification. We will send 5 digits code to your number.",
                                  style: CustomTextStyle(),
                                ),
                              ),
                            ],
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
