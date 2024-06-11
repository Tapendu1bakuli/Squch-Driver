
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/const.dart';


class CommonButton extends StatelessWidget {
  final String? label;
  late Function()? onClicked;
  final Color? labelColor;
  final List<Color>? gradColor;
  final Color? borderColor;
  final double borderRadius;
  final Color? solidColor;
  final double? fontSize;
  final double? buttonHeight;
  final double? buttonWidth;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;

  CommonButton(
      {this.label,
      this.onClicked,
      this.labelColor,
      this.gradColor,
      this.solidColor,
      this.borderColor,
      this.borderRadius = 10.0,
      this.fontSize,
      this.buttonHeight = 50.0,
      this.buttonWidth,
        this.fontWeight,
        this.padding,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding??EdgeInsets.zero,
      child: InkWell(
          onTap: onClicked,
          child: Container(
            // alignment: Alignment.center,
            height: buttonHeight,
            width: buttonWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                gradient: solidColor == null
                    ? LinearGradient(
                        colors: gradColor ?? [AppColors.buttonColor, AppColors.buttonColor])
                    : null,
                color: solidColor,
                border: borderColor != null
                    ? Border.all(
                        color: borderColor!,
                        width: 1.0,
                      )
                    : null,
                borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
            child: Center(
              child: Text(
                label ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: labelColor ?? AppColors.colorWhite,
                    fontSize: fontSize ?? 16,
                    fontFamily: font,
                    fontWeight: fontWeight ?? FontWeight.w700),
              ),
            ),
          )),
    );
  }
}
