import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizing/sizing.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image_utils.dart';
import '../../core/widgets/gap.dart';

class IntroWidget extends StatelessWidget {
  IntroWidget(
      {super.key, this.image, this.title, this.subtitle, this.highLightText});

  final String? image;
  final String? title;
  final String? subtitle;
  final String? highLightText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 6 / 7,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(image!), fit: BoxFit.fitWidth)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20.ss),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.ss),
                  ),
                ),
                height: MediaQuery.sizeOf(context).height / 2.5,
                child: Stack(
                  children: [
                    Positioned(
                        top: 50.ss,
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 10,
                              ),
                              SvgPicture.asset(
                                ImageUtils.splashIcon,
                                color: AppColors.colorWhite,
                              ),
                              Container(
                                width: 10,
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.3),
                  Colors.black,
                  Colors.black
                ],
              ),
            ),
          ),
        ),
        Positioned(
            left: (highLightText?.isEmpty ?? true) ? null : 0,
            right: (highLightText?.isEmpty ?? true) ? null : 0,
            bottom: 210.ss,
            child: (highLightText?.isEmpty ?? true)
                ? const Offstage()
                : Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, 0.0)
                      ..rotateZ(-0.08),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 70.ss),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration:
                          BoxDecoration(color: AppColors.colorTabIndecator),
                      child: Text(
                        highLightText ?? "",
                        textAlign: TextAlign.center,
                        style: CustomTextStyle(
                          color: AppColors.textBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )),
        Positioned(
          bottom: 100.ss,
          child: Padding(
            padding: EdgeInsets.all(20.ss),
            child: Column(
              crossAxisAlignment: (highLightText?.isEmpty ?? true)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Text(
                  title!,
                  style: CustomTextStyle(
                      color: AppColors.colorWhite,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.fss),
                  overflow: TextOverflow.clip,
                ),
                Gap(10.ss),
                Text(
                  subtitle!,
                  style: CustomTextStyle(
                      color: AppColors.colorWhite,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.fss),
                  overflow: TextOverflow.clip,
                ),
                Gap(20.ss),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
