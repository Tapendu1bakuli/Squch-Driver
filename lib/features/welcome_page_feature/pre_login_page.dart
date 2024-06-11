import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:squch_driver/core/shared_pref/shared_pref_impl.dart';
import 'package:squch_driver/features/welcome_page_feature/presentation/controller/introduction_controller.dart';


import '../../../core/service/page_route_service/routes.dart';
import '../../../core/shared_pref/shared_pref.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/image_utils.dart';


class PreLoginPage extends GetView<IntroductionController> {
  const PreLoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: AppColors.buttonColor,
        body: Center(
            child:  SvgPicture.asset(ImageUtils.splashIcon,color: AppColors.colorWhite,)
        )
    );
  }
}

