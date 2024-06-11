import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/utils/image_utils.dart';
import 'package:squch_driver/features/user_auth_feature/presentation/controller/registration_controller.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/fonts.dart';
import '../controller/auth_controller.dart';

class TypeSelectionCardWidget extends StatelessWidget {
  String? title;
  String? subtitle;
  String? topContainerText;
  String? cardImages;
  bool isSelected;
  final Function(bool) onSelected;
  RegistrationController authController;

  TypeSelectionCardWidget(
      {Key? key,
      this.title,
      this.subtitle,
      this.topContainerText,
      this.cardImages,
      this.isSelected = false,
        required this.authController,
      required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? InkWell(
            onTap: () {
                onSelected(!isSelected);
                authController.update();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.ss),
              padding: EdgeInsets.symmetric(horizontal: 16.ss, vertical: 18.ss),
              decoration: ShapeDecoration(
                color: AppColors.iconColor.withOpacity(0.04),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1, color: AppColors.textBlack.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.ss, vertical: 4.ss),
                        decoration: ShapeDecoration(
                          color: AppColors.iconColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: Text(
                          topContainerText ?? "",
                          style: CustomTextStyle(
                            color: AppColors.colorWhite,
                            fontSize: 12.fss,
                            letterSpacing: 0.36,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 22.ss,
                        width: 22.ss,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppColors.textBlack.withOpacity(0.2)),
                        ),
                        child: SvgPicture.asset(
                            ImageUtils.typeSelectionIsSelectedIcon),
                      )
                    ],
                  ),
                  Container(
                    height: 10.ss,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title ?? "",
                              style: CustomTextStyle(
                                color: AppColors.textBlack,
                                fontSize: 16.fss,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              height: 6.ss,
                            ),
                            Text(
                              subtitle ?? "",
                              style: CustomTextStyle(
                                color: AppColors.colordeepgrey,
                                fontSize: 14.fss,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 22.34.ss,
                      ),
                      Container(
                        height: 68.ss,
                        width: 68.ss,
                        child: SvgPicture.asset(cardImages ?? ""),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () {
                onSelected(!isSelected);
                authController.update();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.ss),
              padding: EdgeInsets.symmetric(horizontal: 16.ss, vertical: 18.ss),
              decoration: ShapeDecoration(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1, color: AppColors.textBlack.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.ss, vertical: 4.ss),
                        decoration: ShapeDecoration(
                          color: AppColors.iconColor.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: Text(
                          topContainerText ?? "",
                          style: CustomTextStyle(
                            color: AppColors.iconColor,
                            fontSize: 12.fss,
                            letterSpacing: 0.36,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 22.ss,
                        width: 22.ss,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColors.textBlack.withOpacity(0.2))),
                      ),
                    ],
                  ),
                  Container(
                    height: 10.ss,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title ?? "",
                              style: CustomTextStyle(
                                color: AppColors.textBlack,
                                fontSize: 16.fss,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              height: 6.ss,
                            ),
                            Text(
                              subtitle ?? "",
                              style: CustomTextStyle(
                                color: AppColors.colordeepgrey,
                                fontSize: 14.fss,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 22.34.ss,
                      ),
                      Container(
                        height: 68.ss,
                        width: 68.ss,
                        child: SvgPicture.asset(cardImages ?? ""),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
