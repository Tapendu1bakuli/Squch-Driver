import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:squch_driver/common/widget/introWidget.dart';
import 'package:squch_driver/core/utils/app_strings.dart';
import 'package:squch_driver/core/utils/image_utils.dart';

import '../../../../core/model/dropdown_model.dart';
import '../../../../core/network_checker/common_network_checker_controller.dart';
import '../../../../core/service/LocalizationService.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/Resource.dart';
import '../../../../core/utils/Status.dart';
import '../../../../core/utils/utils.dart';
import '../../data/models/intro_screen_response_model.dart';
import '../../domain/repositories/welcome_repository.dart';

class IntroductionController extends GetxController {
  final SharedPref sharedPref;
  final WelcomeRepository welcomeRepository;

  IntroductionController(
      {required this.sharedPref, required this.welcomeRepository});

  final CommonNetWorkStatusCheckerController _netWorkStatusChecker =
      Get.put(CommonNetWorkStatusCheckerController());
  RxBool isLoading = false.obs;

  final PageController pageController = PageController();
  RxList<Widget> pageList = <Widget>[
    IntroWidget(
      image: ImageUtils.introScreenOne,
      title: AppStrings.introPageOne,
      subtitle: AppStrings.introPageOneSubCaption,
    ),
    IntroWidget(
      image: ImageUtils.introScreenTwo,
      title: AppStrings.introPageTwo,
      subtitle: AppStrings.introPageTwoSubCaption,
    ),
    IntroWidget(
      image: ImageUtils.introScreenThree,
      title: AppStrings.introPageThree,
      subtitle: AppStrings.introPageThreeSubCaption,
    ),
    IntroWidget(
      image: ImageUtils.introScreenFour,
      title: AppStrings.introPageFour,
      subtitle: AppStrings.introPageFourSubCaption,
    ),
    IntroWidget(
      image: ImageUtils.introScreenFive,
      title: AppStrings.introPageFive,
      subtitle: AppStrings.introPageFiveSubCaption,
      highLightText: AppStrings.highLightText,
    ),
  ].obs;
  RxInt index = 0.obs;

  @override
  void onInit() {
    _netWorkStatusChecker.updateConnectionStatus();
    getLanguageData();
    // Get called when controller is created
    super.onInit();
  }

  var languageList = [
    DropdownModel(label: "English", id: "en", uniqueid: 0, dependentId: "en"),
    DropdownModel(label: "Spanish", id: "es", uniqueid: 1, dependentId: "es"),
    DropdownModel(label: "French", id: "fr", uniqueid: 2, dependentId: "fr")
  ].obs;

  Rx<DropdownModel> selectedLanguage =
      DropdownModel(label: "English", id: "en", uniqueid: 0, dependentId: "en")
          .obs;
  Rx<IntroScreenData> howToUseAppData = IntroScreenData().obs;
  Rx<IntroScreenData> cancelBydriverData = IntroScreenData().obs;

  Future<void> changeLanguage() async {
    await sharedPref.setLanguage(selectedLanguage.value.id);
    LocalizationService().changeLocale(lang: selectedLanguage.value.id);
  }

  void getLanguageData() async {
    String? selectdLanguage = await sharedPref.getSelectedLanguage();
    debugPrint("Selected Language ======>> " + selectdLanguage.toString());
    if (selectedLanguage != null) {
      for (var language in languageList) {
        if (selectdLanguage == language.id) {
          selectedLanguage.value = language;
          changeLanguage();
        }
      }
    }
  }

  Future getIntroData(String section) async {
    if (await _netWorkStatusChecker.isInternetAvailable()) {
      isLoading.value = true;
      var body = {"slug": section};
      var header = {"": ""};
      Resource resource = await welcomeRepository.getIntroData(body, header);
      if (resource.status == STATUS.SUCCESS) {
        isLoading.value = false;
        if (section == "driver-canellation-policy") {
          cancelBydriverData.value = resource.data;
        } else {
          howToUseAppData.value = resource.data;
          var sliderImages = howToUseAppData.value.content?.sliders;
          if (sliderImages != null && sliderImages.isNotEmpty) {
            //imgList.clear();
            //for (var slide in sliderImages) {
            //imgList.value.add(slide.image ?? "");
            //}
          }
        }
      } else {
        isLoading.value = false;
        showFailureSnackbar("Failed", resource.message ?? "Data Load Failed");
        Get.back();
      }
    } else {
      Future.delayed(Duration(milliseconds: 500));
      Get.back();
    }
  }

  void tapNext() {
    index.value++;
    pageController.animateToPage(index.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastEaseInToSlowEaseOut);
    if(index.value == 4) sharedPref.setIntroScreenShown(true);
  }

  void onSkip() {
    index.value = 4;
    pageController.animateToPage(pageList.length,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn);
    sharedPref.setIntroScreenShown(true);
  }
}
