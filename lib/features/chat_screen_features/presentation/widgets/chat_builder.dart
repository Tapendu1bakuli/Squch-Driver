import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';


import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/fonts.dart';
import '../../../../core/utils/screen_constants.dart';

class ChatBuilder extends StatelessWidget {
  const ChatBuilder(
      {Key? key,
        this.message = "",
        this.isPaid = false,
        this.senderType = ""})
      : super(key: key);
  final String? senderType;
  final String? message;
  final bool? isPaid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: senderType == "driver"!
          ? EdgeInsets.only(
        left: ScreenConstant.screenWidthHalf,
        right: ScreenConstant.sizeLarge,
        top: ScreenConstant.sizeExtraSmall,
        bottom: ScreenConstant.sizeExtraSmall,
      )
          : EdgeInsets.only(
        left: ScreenConstant.sizeLarge,
        right: ScreenConstant.screenWidthHalf,
        top: ScreenConstant.sizeExtraSmall,
        bottom: ScreenConstant.sizeExtraSmall,
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: senderType=="driver"?CrossAxisAlignment.end:CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: senderType=="driver"?AppColors.buttonColor:AppColors.colorlightgrey2,borderRadius: senderType=="driver"?BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12),bottomLeft: Radius.circular(12)):BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12),bottomRight: Radius.circular(12))),
              child: Padding(
                padding: ScreenConstant.spacingAllMedium,
                child: senderType=="driver"!
                    ? Text(
                  message??"",
                  style: CustomTextStyle(fontSize: 12.ss,color: AppColors.colorInviteFriendHome,fontWeight: FontWeight.w500),
                )
                    : Text(message??"",
                    style: CustomTextStyle(fontSize: 12.ss,color: AppColors.colorBlack,fontWeight: FontWeight.w500)),
              ),
            ),
            Container(height: 2.ss,),
            senderType=="driver"?Text("Delivered",style: CustomTextStyle(color: AppColors.titleColor,fontWeight: FontWeight.w400,fontSize: 10.fss),):Offstage()
          ],
        ),
      ),
    );
  }
}
