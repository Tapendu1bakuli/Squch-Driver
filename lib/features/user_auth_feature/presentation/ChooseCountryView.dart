import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/service/page_route_service/routes.dart';
import 'package:squch_driver/core/utils/app_colors.dart';
import 'package:squch_driver/core/utils/fonts.dart';
import 'package:squch_driver/core/widgets/gap.dart';
import 'package:squch_driver/features/user_auth_feature/presentation/controller/registration_controller.dart';
import '../../../core/common/common_button.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/utils.dart';

class ChooseCountryView extends GetView<RegistrationController> {
  const ChooseCountryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CommonButton(
        padding: EdgeInsets.symmetric(horizontal: 20.ss, vertical: 20.ss),
        label: AppStrings.done.tr,
        onClicked: () {
          if(controller.selectedCountry == null){
            showFailureSnackbar(AppStrings.oops,AppStrings.pleaseSelectCountry.tr);
          }else {
            controller.clearTypeSelection();
            Get.toNamed(Routes.TYPESELECTION,arguments: {"selectedCountry": controller.selectedCountry});
          }
        },
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Gap(24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.ss),
            child: Text(
              AppStrings.chooseContryTitle.tr,
              style: CustomTextStyle(
                color: AppColors.textBlack,
                fontSize: 20.fss,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.ss),
            child: Text(
              AppStrings.chooseContrySubTitle,
              style: CustomTextStyle(
                color: AppColors.textSubBlack,
                fontSize: 14.fss,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Gap(20.ss),
          Obx(
            () => controller.isInitialLoading.isTrue
                ? SizedBox(
                    height: Get.height / 2,
                    child: const Center(child: CircularProgressIndicator()))
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 10.ss),
                    physics: const ClampingScrollPhysics(),
                    itemCount: controller.countryList.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: CachedNetworkImage(
                            height: 32.ss,
                            width: 32.ss,
                            imageUrl:
                                controller.countryList[i].flag.toString()),
                        title: Text(
                          controller.countryList[i].name.toString(),
                          style: CustomTextStyle(
                            color: AppColors.textBlack,
                            fontSize: 14.fss,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Checkbox(
                          activeColor: AppColors.iconColor,
                          tristate: true,
                          checkColor: AppColors.colorWhite,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.ss)),
                          value: controller.countryList[i].isSelected,
                          onChanged: (bool? value) {
                            if(value == true) {
                              controller.selectedCountry = controller
                                  .countryList[i];
                            }else{
                              controller.selectedCountry = null;
                            }
                            controller.countryList[i].isSelected =
                                !(controller.countryList[i].isSelected ??
                                    false);
                            for(int j =0;j<controller.countryList.length;j++){
                              if(i!=j){
                                controller.countryList[j].isSelected = false;
                              }
                            }

                            controller.countryList.refresh();
                          },
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
