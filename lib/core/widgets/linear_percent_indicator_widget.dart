import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizing/sizing.dart';

import '../utils/app_colors.dart';

class LinearPercentIndicatorWidget extends StatelessWidget {
  final progressColor;
  final backgroundColor;
  final isRTL;
  final animationDuration;
  final animation;
  final restartAnimation;
  final alignment;
  final percent;
  final padding;
  final lineHeight;
  final onAnimationEnd;
  final createdAt;

  LinearPercentIndicatorWidget(
      {super.key,
      this.progressColor = AppColors.colorLightGrey,
      this.backgroundColor = AppColors.colorLoaderFill,
      this.isRTL = true,
      this.animationDuration = 3000,
      this.animation = true,
      this.restartAnimation = false,
      this.alignment = MainAxisAlignment.start,
      this.percent = 1.0,
      this.padding = EdgeInsets.zero,
      this.onAnimationEnd,
      this.createdAt,
      this.lineHeight});

  @override
  Widget build(BuildContext context) {
    int timerDuration  = getDuration();
    double calculatedProgress  = getProgress();
    return LinearPercentIndicator(
      animation: animation ?? true,
      restartAnimation: restartAnimation ?? false,
      alignment: alignment,
      percent: 1.0,
      animateFromLastPercent: true,
      isRTL: isRTL,
      animationDuration: timerDuration,
      padding: padding,
      lineHeight: lineHeight ?? 5.0.ss,
      backgroundColor: backgroundColor,
      progressColor: progressColor,
      onAnimationEnd: onAnimationEnd,
    );
  }
  int getDuration(){
    DateTime? endTime = DateTime.tryParse(createdAt)
        ?.add(Duration(milliseconds: animationDuration??0));
    DateTime currentTime = DateTime.now();
    Duration? duration = currentTime.difference(endTime??DateTime.now());
    print("CreatedAt: $createdAt");
    print("animationDuration: $animationDuration");
    print("EndAt: $endTime");
    print("difference inSeconds: ${(duration?.inSeconds??0)>0?0:(duration?.inSeconds??0).abs()}");
    return (duration?.inMilliseconds??0)>0?0:(duration?.inMilliseconds??0).abs();
  }
  double getProgress(){
    DateTime? endTime = DateTime.tryParse(createdAt)
        ?.add(Duration(milliseconds: animationDuration??0));
    DateTime currentTime = DateTime.now();
    Duration? duration = currentTime.difference(endTime??DateTime.now());
    double calculatedProgress = (duration?.inMilliseconds??0)>0?0:(duration?.inMilliseconds??0).abs()/animationDuration;
    print("calculatedProgress: $calculatedProgress");

    return calculatedProgress;
  }
}
