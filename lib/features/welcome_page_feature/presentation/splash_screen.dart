import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/shared_pref/shared_pref_impl.dart';
import 'package:squch_driver/features/user_auth_feature/data/models/login_response.dart';


import '../../../core/service/page_route_service/routes.dart';
import '../../../core/shared_pref/shared_pref.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final UberAuthController _uberAuthController =
  //     Get.put(di.sl<UberAuthController>());
  // final UberNetWorkStatusChecker _netWorkStatusChecker =
  //     Get.put(di.sl<UberNetWorkStatusChecker>());

  @override
  void initState() {
    // _netWorkStatusChecker.updateConnectionStatus();
    // _uberAuthController.checkIsSignIn();
    Timer(const Duration(seconds: 3), () async {
      SharedPref sharedPref = Get.put(SharedPrefImpl());
      bool introScreanLoad = await sharedPref.isIntroScreenShown();
      bool isLoggedIn = await sharedPref.isLoggedin();
      LoginData? logedinData = await sharedPref.getLogindata();

      if(introScreanLoad){
        if(isLoggedIn && logedinData != null){
          if(logedinData.user!.driverDocument!.documentStatus == "pending" || logedinData.user!.driverDocument!.documentStatus == "rejected" ) {
            Get.offNamed(Routes.DRIVER_DETAILS_LISTING);
          }
          else{
            Get.offNamed(Routes.DASHBOARD);
          }
        }
        else {
          Get.offNamed(Routes.LANDING);
        }
      }else{
        Get.offNamed(Routes.INTRODUCTION);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageUtils.splashBackgroundImage),
              fit: BoxFit.fill,
            ),
          ),
          child:  Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment:MainAxisAlignment.center,children: [
            SvgPicture.asset(ImageUtils.appbarTopLogo,height: 88.38.ss,width: 93.18.ss,),
            Container(height: 10.ss,),
            SvgPicture.asset(ImageUtils.splashBackgroundTextImage,height: 40.95.ss,width: 126.59.ss,),
          ],))
      ),
    );
  }
}
