/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/utils/app_colors.dart';
import 'package:squch_driver/core/utils/app_strings.dart';
import 'package:squch_driver/core/utils/fonts.dart';
import 'package:squch_driver/core/utils/image_utils.dart';
import 'package:squch_driver/features/dashboard_feature/presentation/controller/dashboard_controller.dart';

import '../../common/widget/flutter_switch.dart';
import '../service/page_route_service/routes.dart';
import '../utils/utils.dart';
import 'drawer_link_widget.dart';

class MainDrawerWidget extends StatelessWidget {
  DashboardController _dashboardController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.ss,vertical: 40.ss),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  child: Container(
                    height: 36.ss,
                    width: 36.ss,
                    child: CachedNetworkImage(
                      height: 80,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl:
                      _dashboardController.logedinData?.user?.profileImage ?? "",
                      placeholder: (context, url) => Image.asset(
                        ImageUtils.loadingImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 80,
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error_outline),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_dashboardController.logedinData?.user?.firstName} ${_dashboardController.logedinData?.user?.lastName}",
                      style: CustomTextStyle(fontWeight: FontWeight.w700,fontSize: 18.fss),
                    ),
                    Text(
                      "${_dashboardController.logedinData?.user?.email}",
                      style: CustomTextStyle(fontWeight: FontWeight.w400,fontSize: 12.fss),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20.ss),
            Divider(color: AppColors.bottomDividerColor,),
            SizedBox(width: 20.ss),
            // DrawerLinkWidget(
            //   icon: Icons.delete,
            //   text: 'delete_account',
            //   onTap: (e) {
            //     _showDeleteDialog(context);
            //   },
            // ),
           Obx(()=>_dashboardController.isLoading.value?const Center(child: CircularProgressIndicator(),): DrawerLinkWidget(
                icon: ImageUtils.logoutIcon,
                text: AppStrings.logout,
                onTap: (e) async {
                  print("Logout");
                  showLogoutDialog(() {
                    _dashboardController.logout();
                  },);
                },
              ),
           ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete your account!".tr,
            style: TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("delete_your_account_warning".tr,
                    style: Get.textTheme.bodyLarge),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("cancel".tr, style: Get.textTheme.bodyLarge),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "confirm".tr,
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () async {
                // Get.back();
                // await deleteUser();
                // await Get.offAllNamed(Routes.LOGIN);
              },
            ),
          ],
        );
      },
    );
  }
}
