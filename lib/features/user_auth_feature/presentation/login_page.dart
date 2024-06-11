import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/common/common_button.dart';
import '../../../core/common/common_text_form_field.dart';
import '../../../core/service/page_route_service/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/utils/validator.dart';
import '../../../core/widgets/gap.dart';
import '../../../core/widgets/horizontal_gap.dart';
import '../../../core/widgets/title_text.dart';
import 'controller/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return
      Obx(()=> SafeArea(
        top: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height/10 ,
                  width: size.width,
                ),
                SvgPicture.asset(ImageUtils.loginTopLogo),
                Gap(20.ss),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.ss),
                  child: Form(
                    key:  controller.userLoginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(AppStrings.hiWelcomeBack.tr,style: CustomTextStyle(
                              color:AppColors.titleColor, fontWeight: FontWeight.w800,fontSize: 20.fss
                          ),),
                        ),
                        Gap(18.ss),
                        TitleText(context, AppStrings.userNameUserId.tr),
                        Gap(8.ss),
                        CommonTextFormField(
                          margin: 0,
                          padding: 0,
                          controller:  controller.emailController,
                          isEnable: ! controller.isLoading.value,
                          onValidator: Validator().validateEmail,
                          inputFormatters: [LowerCaseTextFormatter()],
                          hintText: AppStrings.userNameUserId.tr,
                        ),
                        Gap(18.ss),
                        TitleText(context, AppStrings.password.tr),
                        Gap(8.ss),
                        CommonTextFormField(
                          margin: 0,
                          padding: 0,
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
                          controller:  controller.passwordController,
                          onValidator: Validator().validatePassword,
                          isEnable: ! controller.isLoading.value,
                          hintText: AppStrings.password.tr,
                          
                        ),
                        Gap(18.ss),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IgnorePointer(
                                  ignoring:  controller.isLoading.value,
                                  child: Checkbox(
                                    materialTapTargetSize: MaterialTapTargetSize.padded,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    value:  controller.rememberMe.value,
                                    focusColor: Theme.of(context).brightness != Brightness.dark   ? AppColors.colorWhite : AppColors.titleColor,
                                    checkColor: Theme.of(context).brightness != Brightness.dark   ? AppColors.colorWhite : AppColors.titleColor,
                                    onChanged: (value){
                                       controller.rememberMe.value= value??false;
                                    },
                                  ),
                                ),
                                Text(AppStrings.rememberMe.tr,style: CustomTextStyle(
                                    color:AppColors.buttonColor, fontWeight: FontWeight.w800,fontSize: 14.fss
                                ),)
                              ],
                            ),
                            InkWell(
                              onTap:(){
                                Get.toNamed(Routes.FORGOT_PASSWORD);
                              },
                              child: Text(AppStrings.forgotPasswordText.tr,style: CustomTextStyle(
                                  color:AppColors.buttonColor, fontWeight: FontWeight.w800,fontSize: 14.fss
                              ),),
                            ),
                          ],
                        ),
                        Gap(20.ss),
                         controller.isLoading.value?
                        Center(child: CircularProgressIndicator()):
                        CommonButton(label: AppStrings.signIn.tr,onClicked: (){
                           controller.login();
                        },),

                        Gap(22.ss),

                        Row(
                          children: [
                            Expanded(child: Divider(thickness: 1.ss,color: AppColors.dividerColor,)),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 30.ss),child:
                            Text(AppStrings.or.tr),),
                            Expanded(child: Divider(thickness: 1.ss,color: AppColors.dividerColor,)),
                          ],
                        ),
                        Gap(22.ss),
                        SocialButton(ImageUtils.google, AppStrings.ContinueWithGoogle.tr,context),
                        Gap(14.ss),
                        InkWell(
                            onTap: (){
                               controller.handleAppleSignIn();
                            },
                            child: SocialButton(ImageUtils.apple, AppStrings.ContinueWithApple.tr,context)),
                        Gap(14.ss),
                        InkWell(
                            onTap: ()async{
                              await  controller.fbLogin();
                            },
                            child: SocialButton(ImageUtils.facebook, AppStrings.ContinueWithFacebook.tr,context)),
                        Gap(41.ss),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child:
                              InkWell(
                                onTap: (){
                                  Get.toNamed(Routes.CHOOSECOUNTRY);
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: AppStrings.NewUserText.tr,
                                    style: CustomTextStyle(color: Colors.grey),
                                    children: [
                                      TextSpan(text: AppStrings.signUp.tr, style: CustomTextStyle(color: AppColors.buttonColor,fontWeight: FontWeight.w800)),
                                    ],

                                  ),
                                ),
                              ),

                            ),
                          ],
                        ),
                        Gap(20.ss),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ));
  }

  Widget SocialButton(String assetIcon, String title, BuildContext context) {
    return Container(
      height: 50.ss,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.ss)),
        border: Border.all(color: AppColors.colorgrey)
      ),
      child: Center(
        child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(assetIcon),
            SvgPicture.asset(
              assetIcon,
            ),
            HorizontalGap(10.ss),
            Flexible(child: TitleText(context, title))
          ],
        ),
      ),
    );
  }
}
