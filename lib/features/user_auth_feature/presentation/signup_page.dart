

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/common_button.dart';
import '../../../core/common/common_dropdown.dart';
import '../../../core/common/common_text_form_field.dart';
import '../../../core/service/page_route_service/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/utils/validator.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/gap.dart';
import '../../../core/widgets/title_text.dart';
import 'controller/registration_controller.dart';
import 'package:sizing/sizing.dart';

class SignUpPage extends GetView<RegistrationController> {
  const SignUpPage({super.key});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/12),
        child: CommonAppbar(title:AppStrings.CreateYourAccount.tr,isIconShow: true,onPressed: (){Get.back();},
        ),
      ),
      body:  Obx(()=>SafeArea(
        child:
        controller.isInitialLoading.value?
        Center(child: CircularProgressIndicator())
            :
        SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0.ss),
              child: Form(
                key:  controller.userRegistrationFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(20.ss),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(left: 20.0.ss),
                                  child: TitleText(context,AppStrings.Name.tr),
                                ),
                                Gap(10.ss),
                                CommonTextFormField(
                                  hintText: AppStrings.enterName.tr,
                                  controller:  controller.firstNameController,
                                  onValidator: (name){
                                    if (name==null || name.isEmpty) {
                                      return AppStrings.enterName.tr;
                                    }
                                  },
                                )
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Padding(
                                  padding:  EdgeInsets.only(left: 5.0.ss),
                                  child: TitleText(context,AppStrings.LastName.tr),
                                ),
                                Gap(10.ss),
                                Padding(
                                  padding:  EdgeInsets.only(right: 20.0.ss,left: 0.ss),
                                  child: CommonTextFormField(
                                    hintText: AppStrings.enterLastName.tr,
                                    padding: 0,
                                    margin: 0,
                                    controller:  controller.lastNameController,
                                    onValidator: (name){
                                      if ( name==null || name.isEmpty) {
                                        return AppStrings.enterLastName.tr;
                                      }
                                    },
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                    Gap(20.ss),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20.0.ss),
                      child: TitleText(context,AppStrings.phoneNumber.tr),
                    ),
                    Gap(10.ss),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.ss),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.ss),),
                          border: Border.all(width:  controller.isValidPhoneNo.value == false? 1.ss: 0.5.ss,color:   controller.isValidPhoneNo.value == false?Colors.red: Colors.black ,)
                      ),
                      child: Row(
                        children: [
                          //CommonTextFormField(width: MediaQuery.sizeOf(context).width/4,),
                          Container(width: MediaQuery.sizeOf(context).width/4,
                            child: CountryCodePicker(
                              onChanged: (newValue){
                                controller.selectedCountryCode.value = newValue.dialCode??"+91";
                              },
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection:  controller.selectedCountryCode.value,
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
                            height: 50.ss,
                            controller:  controller.phoneNumberController,
                            textInputType: TextInputType.number,
                            maxLength: 10,
                            //  onValidator: Validator().validateMobile,
                            onValueChanged: (value){
                              controller.phoneValidationMsg.value = Validator().validateMobile(value)??"";
                              if(Validator().validateMobile(value)!= null){
                                controller.isValidPhoneNo.value = false;
                              }else  controller.isValidPhoneNo.value = true;
                            },
                            decoration: InputDecoration(
                                hintText: "${AppStrings.Enter} "+AppStrings.phoneNumber.tr,
                                border: InputBorder.none,
                                counterText: "",
                              hintTextDirection: TextDirection.ltr,
                              contentPadding: EdgeInsets.symmetric(horizontal: 0.ss,vertical: 15.ss),
                              hintStyle: CustomTextStyle(
                                  color:Theme.of(context).brightness != Brightness.dark   ? AppColors.textSubBlack : Colors.white,fontSize: 14.fss),
                            ),

                          )),
                        ],
                      ),
                    ),

                    Visibility(visible:  ! controller.isValidPhoneNo.value &&  controller.phoneValidationMsg.value.isNotEmpty,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20.0.ss,vertical: 5.ss),
                        child: Text(
                          controller.phoneValidationMsg.value,style: CustomTextStyle(color: Colors.red),
                        ),
                      ),),

                    Gap(20.ss),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20.0.ss),
                      child: TitleText(context,AppStrings.emailAddress.tr),
                    ),
                    Gap(10.ss),
                    CommonTextFormField(
                      hintText: AppStrings.enterEmailAddress.tr,
                      textInputType: TextInputType.emailAddress,
                      controller:  controller.emailController,
                      onValidator: Validator().validateEmail,
                      inputFormatters: [LowerCaseTextFormatter()],
                    ),
                    Gap(20.ss),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20.0.ss),
                      child: TitleText(context,AppStrings.address.tr),
                    ),
                    Gap(10.ss),
                    CommonTextFormField(
                      hintText: AppStrings.enterAddress.tr,
                      textInputType: TextInputType.text,
                      controller:  controller.addressController,
                      onValidator: (value){
                        if(value == null || value.isEmpty) return AppStrings.enterAddress.tr;
                        else return null;
                      },
                     // inputFormatters: [LowerCaseTextFormatter()],
                    ),
                    Gap(20.ss),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20.0.ss),
                      child: TitleText(context,AppStrings.password.tr),
                    ),
                    Gap(10.ss),
                    CommonTextFormField(
                      hintText: AppStrings.enterPassword.tr,
                      controller:  controller.passwordController,
                      onValidator: Validator().validatePassword,
                      obscureText: controller.toggleObscured.value,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: () {
                            controller.toggleObscured.isTrue ?
                            controller.toggleObscured.value = false
                                : controller.toggleObscured.value = true;
                          },
                          child: Icon(
                            controller.toggleObscured.isFalse
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: 24.ss,
                            color: AppColors.colordeepgrey,
                          ),
                        ),
                      ),
                    ),
                    Gap(20.ss),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20.0.ss),
                      child: TitleText(context,AppStrings.confirmPassword.tr),
                    ),
                    Gap(10.ss),
                    CommonTextFormField(
                      hintText:AppStrings.enterConfirmPassword.tr,
                      controller:  controller.confirmPasswordController,
                      onValidator: (name){
                        if (  controller.confirmPasswordController.text==null ||  controller.confirmPasswordController.text.isEmpty) {
                          return AppStrings.enterConfirmPassword.tr;
                        } else if ( controller.confirmPasswordController.text!= controller.passwordController.text) {
                          return AppStrings.passwordDoesNotMatch.tr;
                        } else {
                          return null;
                        }
                      },
                      obscureText: controller.toggleObscuredConfirm.value,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: () {
                            controller.toggleObscuredConfirm.isTrue ?
                            controller.toggleObscuredConfirm.value = false
                                : controller.toggleObscuredConfirm.value = true;
                          },
                          child: Icon(
                            controller.toggleObscuredConfirm.isFalse
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: 24.ss,
                            color: AppColors.colordeepgrey,
                          ),
                        ),
                      ),
                      // onValidator: Validator().validateConfirmPassword(_registrationController.passwordController.text,_registrationController.confirmPasswordController.text),
                    ),
                    /* Gap(10.ss),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20.0.ss),
                        child: Row(
                          children: [
                            ImageIcon(AssetImage(ImageUtils.closeCircle),color: Colors.red,),
                            HorizontalGap(5.ss),
                            Text("Password Strength: Weak",style: CustomTextStyle(
                              color: Colors.red,
                            ),)
                          ],
                        ),
                      ),*/
                    Gap(MediaQuery.sizeOf(context).height/12),

                    controller.isLoading.value?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    )
                        : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.ss,vertical: 10.ss),
                      child: CommonButton(label:AppStrings.Save.tr,onClicked: (){
                        //Get.offAllNamed(Routes.VERIFY_OTP_PAGE);
                        controller.signup();
                      //  Get.toNamed(Routes.DRIVER_DETAILS_LISTING);
                        //controller.signup();
                      },),
                    ),
                  ],
                ),
              ),
            )),
      )),

    );
  }
}
