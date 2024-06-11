import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/utils/image_utils.dart';

import '../utils/app_colors.dart';
import '../utils/fonts.dart';

class RatingWithCarWidget extends StatelessWidget {
  final String? profileImage;
  final String? rating;

  RatingWithCarWidget(
      {super.key, this.profileImage, this.rating});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 42,
          width: 42,
        ),
        profileImage != null
            ? Positioned(
                right: 0,
                child: CircleAvatar(
                    backgroundColor: AppColors.colorWhite,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.ss)),
                          child: Image.asset(
                            ImageUtils.carImage4xAtBiddingCard,
                            width: 38.ss,
                            height: 38.ss,
                            fit: BoxFit.fill,
                          )),
                    )))
            : const Offstage(),
        Positioned(
          bottom: -5.ss,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0.ss),
            margin: EdgeInsets.symmetric(horizontal: 5.0.ss),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.5),
                color: Colors.white),
            child: Text(rating ?? "",
                textAlign: TextAlign.center,
                style: CustomTextStyle(
                  fontSize: 12.fss,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ),
      ],
    );
  }
}
