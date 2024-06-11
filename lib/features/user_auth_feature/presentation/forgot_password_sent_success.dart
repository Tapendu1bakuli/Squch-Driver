import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';
import 'package:get/get.dart';

import '../../../core/common/common_button.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/widgets/gap.dart';

class ForgotPasswordSentSuccess extends StatefulWidget {
  const ForgotPasswordSentSuccess({super.key});

  @override
  State<ForgotPasswordSentSuccess> createState() => _ForgotPasswordSentSuccessState();
}

class _ForgotPasswordSentSuccessState extends State<ForgotPasswordSentSuccess> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.sizeOf(context).height-20,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ImageUtils.resetPasswordSentLock),
                        Gap(10.ss),
                        Text("Reset Password",style: CustomTextStyle(fontSize: 18.fss, fontWeight: FontWeight.w800),),
                        Gap(10.ss),
                        Text("We have sent a reset password link to your email ",style: CustomTextStyle(fontSize: 14.fss, fontWeight: FontWeight.w600,color: AppColors.titleColor.withOpacity(0.5)),),
                        Gap(10.ss),
                        Text("johnsmith1001@gmail.com",style: CustomTextStyle(fontSize: 14.fss, fontWeight: FontWeight.w800,color: AppColors.buttonColor),),

                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20.ss,
                    right: 10.ss,
                    left: 10.ss,
                    child: InkWell(
                      onTap: (){

                      },
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20.0.ss,vertical: 20.ss),
                        child: CommonButton(label:AppStrings.done.tr,),
                      ),
                    ),)
                ],
              ),
            ),
          ),
        )
    );
  }
}
