import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/common/common_button.dart';
import '../../../core/service/page_route_service/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/gap.dart';
import '../../../core/widgets/title_text.dart';
import 'package:sizing/sizing.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';

import 'controller/registration_controller.dart';

class VerifyRegistrationOtp extends StatefulWidget {
  const VerifyRegistrationOtp({super.key});

  @override
  State<VerifyRegistrationOtp> createState() => _VerifyRegistrationOtpState();
}

class _VerifyRegistrationOtpState extends State<VerifyRegistrationOtp> {

  final RegistrationController _registrationController = Get.find();
  @override
  Widget build(BuildContext context) {
    print("Token1:${_registrationController.registrationSuccessData!.token}");
    final defaultPinTheme = PinTheme(
      width: 56.ss,
      height: 56.ss,
      textStyle: TextStyle(fontSize: 20.fss, color: AppColors.titleColor.withOpacity(0.7), fontWeight: FontWeight.w600),
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
        color: !_registrationController.isMobileVerified.value? AppColors.colorlightgrey1: AppColors.colorGreen,
      ),
    );
    final submittedEmailPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: !_registrationController.isEmailVerified.value? AppColors.colorlightgrey1: AppColors.colorGreen,
      ),
    );
    return  SafeArea(
      top: true,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/12),
          child: CommonAppbar(title:AppStrings.verifyWithOtp.tr,isIconShow: true,onPressed: (){Get.back();}
          ),
        ),
        body:
        Obx(()=>
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.ss),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(20.ss),
                TitleText(context,AppStrings.verifyPhoneNumber.tr),
                Gap(10.ss),
              Pinput(
                enabled: !_registrationController.isMobileVerified.value,
              androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
              controller: _registrationController.pinController,
                length: 5,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                validator: (s) {
                  return (s==null || s.isEmpty)? "Enter Otp":  s.length<5? "Enter valid otp" : null;
                },
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) => _registrationController.verifyMobileOtp(),
            ),
                Gap(10.ss),
                Visibility(
                  visible: !_registrationController.isMobileVerified.value,
                  child: Container(
                    child:
                    InkWell(
                      onTap: (){
                        _registrationController.resendOTP("MOBILE");
                      },
                      child: RichText(
                        text: TextSpan(
                          text: AppStrings.DidntReceiveIt.tr,
                          style: CustomTextStyle(color: Colors.grey),
                          children: [
                            TextSpan(text: AppStrings.ResendOTP.tr, style: CustomTextStyle(color: AppColors.buttonColor,fontWeight: FontWeight.w600)),
                          ],

                        ),
                      ),
                    ),

                  ),
                ),

                Visibility(
                  visible: _registrationController.isMobileVerified.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.ss),
                        child: Divider(color: AppColors.colorgrey,thickness: 1.ss),
                      ),

                      TitleText(context,AppStrings.verifyEmailId.tr),
                      Gap(10.ss),
                      Pinput(
                        enabled: !_registrationController.isEmailVerified.value,
                        androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                        controller: _registrationController.emailPinController,
                        length: 5,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedEmailPinTheme,
                        validator: (s) {
                          return (s==null || s.isEmpty)? "Enter Otp":  s.length<5? "Enter valid otp" : null;
                        },
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        onCompleted: (pin) => _registrationController.verifyEmailOtp(),
                      ),
                      Gap(10.ss),
                      Container(
                        child:
                        InkWell(
                          onTap: ((){
                            _registrationController.resendOTP(_registrationController.isEmailVerified.value?"PHONE":"EMAIL");
                          }),
                          child: RichText(
                            text: TextSpan(
                              text: AppStrings.DidntReceiveIt.tr,
                              style: CustomTextStyle(color: Colors.grey),
                              children: [
                                TextSpan(text: AppStrings.ResendOTP.tr, style: CustomTextStyle(color: AppColors.buttonColor,fontWeight: FontWeight.w600)),
                              ],

                            ),
                          ),
                        ),

                      ),
                    ],
                  ),
                ),


                Gap(60.ss),
               _registrationController.isLoading.value?
               Center(child: CircularProgressIndicator(),)
               :Column(
                 children: [
                   CommonButton(label:AppStrings.verifyOTP.tr,onClicked: (){
                     !_registrationController.isMobileVerified.value?
                     _registrationController.verifyMobileOtp():
                     _registrationController.verifyEmailOtp();
                   },),

                /*   Gap(10.ss),
                   Visibility(
                     visible: _registrationController.isMobileVerified.value,
                     child: CommonButton(label:AppStrings.skipEmailVerifyOTP.tr,onClicked: (){
                       _registrationController.verifyEmailOtp(isSkip: "1");
                     },),
                   ),*/
                 ],
               ),
                Gap(20.ss)

            ],
            ),
          ),
        )),
      ),
    );
  }
}
