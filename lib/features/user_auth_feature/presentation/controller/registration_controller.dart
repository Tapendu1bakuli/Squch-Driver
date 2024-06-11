
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import 'package:squch_driver/core/utils/app_strings.dart';
import 'package:squch_driver/core/utils/image_utils.dart';

import '../../../../core/model/country_model.dart';
import '../../../../core/model/dropdown_model.dart';
import '../../../../core/network_checker/common_network_checker_controller.dart';
import '../../../../core/network_checker/common_no_network_widget.dart';
import '../../../../core/service/page_route_service/routes.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/Resource.dart';
import '../../../../core/utils/Status.dart';
import '../../../../core/utils/utils.dart';
import '../../data/models/driver_details_item.dart';
import '../../data/models/registration_master_data_model.dart';
import '../../data/models/registration_success_response.dart';
import '../../data/models/type_selection_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../verify_registration_otp.dart';
class RegistrationController extends GetxController{
  final SharedPref sharedPref;
  final AuthRepository authRepository;
  RegistrationController({required this.sharedPref,required this.authRepository});

  RxList<CountryModel> countryList = <CountryModel>[].obs;
  CountryModel? selectedCountry;


  RxList<TypeSelectionModel> typeSelectionList = [
    TypeSelectionModel(typeSelectionTitle:AppStrings.typeSelectionDisabledCardTitle.tr,typeSelectionSubTitle: AppStrings.typeSelectionDisabledCardSubTitle.tr,typeSelectionTopContainerText: "${AppStrings.vehicle.tr}: ${AppStrings.car.tr}, ${AppStrings.motorbike.tr}",typeSelectionContainerIcons:ImageUtils.typeSelectionTopCardIcon,isSelected: false,value: "grocery"),
    TypeSelectionModel(typeSelectionTitle:AppStrings.typeSelectionEnabledCardTitle.tr,typeSelectionSubTitle: AppStrings.typeSelectionEnabledCardSubTitle.tr,typeSelectionTopContainerText: AppStrings.rides.tr,typeSelectionContainerIcons:ImageUtils.typeSelectionBottomCardIcon,isSelected: false,value: "taxi"),
  ].obs;
  TypeSelectionModel? selectedType;
  //RegistrationPage
  final userRegistrationFormKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();



  RxBool isValidPhoneNo = true.obs;
  RxBool toggleObscured = true.obs;
  RxBool toggleObscuredConfirm = true.obs;

  RxString phoneValidationMsg = "".obs;

  RxString selectedCountryCode = "+91".obs;

/*  RxList<DropdownModel> countryList = [
    DropdownModel(uniqueid: -1,id: "-1",label: "Select",)
  ].obs;*/

  RxList<DropdownModel> languageList = [
    DropdownModel(uniqueid: -1,id: "-1",label: "Select",)
  ].obs;
  RxList<DropdownModel> currencyList = [
    DropdownModel(uniqueid: -1,id: "-1",label: "Select",)
  ].obs;

 // Rx<DropdownModel> selectedCountry =  DropdownModel(uniqueid: -1,id: "-1",label: "Select",).obs;
  Rx<DropdownModel> selectedLanguage =  DropdownModel(uniqueid: -1,id: "-1",label: "Select",).obs;
  Rx<DropdownModel> selectedCurrency =  DropdownModel(uniqueid: -1,id: "-1",label: "Select",).obs;



  RxBool isTermAndConditionChecked = false.obs;
  RxBool iAmNotARobot = false.obs;

  RxBool isInitialLoading = false.obs;
  RxBool isLoading = false.obs;

  RegistrationSuccessData? registrationSuccessData;

  //Otp Page

  RxBool isMobileVerified = false.obs;
  RxBool isEmailVerified = false.obs;

  final pinController = TextEditingController();
  final emailPinController = TextEditingController();
  final CommonNetWorkStatusCheckerController _netWorkStatusChecker = Get.put(CommonNetWorkStatusCheckerController());



  @override
  void onInit(){
    selectedType= null;

    // Get called when controller is created
_netWorkStatusChecker.updateConnectionStatus();
getInitialData();
    super.onInit();
  }

  @override
  void onReady(){
    // Get called after widget is rendered on the screen
    super.onReady();
  }

  @override
  void onClose(){
    //Get called when controller is removed from memory
    super.onClose();
  }

  Future signup()async{
    if (!userRegistrationFormKey.currentState!.validate()) {
      return;
    }else if (selectedCountry==null) {
      Get.closeAllSnackbars();
      showFailureSnackbar(AppStrings.oops.tr,AppStrings.pleaseSelectCountry.tr);
    }else if (phoneNumberController.text.isEmpty) {
      isValidPhoneNo.value = false;
      Get.closeAllSnackbars();
      showFailureSnackbar(AppStrings.oops.tr,"Enter phone number");
    }/*else if (selectedLanguage.value.id =="-1") {
      Get.closeAllSnackbars();
      showFailureSnackbar(AppStrings.oops.tr,"Please select language");
    }else if (selectedCurrency.value.id =="-1") {
      Get.closeAllSnackbars();
      showFailureSnackbar(AppStrings.oops.tr,"Please select currency");
    }
    else if(iAmNotARobot.value == false){
      Get.closeAllSnackbars();
      showFailureSnackbar(AppStrings.oops.tr,"Please verify you are not a robot");
    }else if(isTermAndConditionChecked.value == false){
      Get.closeAllSnackbars();
      showFailureSnackbar(AppStrings.oops.tr,"Please agree with the terms & conditions");
    }*/
    else{
      if(await _netWorkStatusChecker.isInternetAvailable()) {
        isLoading.value = true;
        String fcm_token = await sharedPref.getFCMToken();
        var body = {
          "driverType": selectedType?.value,
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "email": emailController.text,
          "countryCode": selectedCountryCode.value,
          "mobile": phoneNumberController.text,
          "address": addressController.text,
          "password": passwordController.text,
          "passwordConfirmation": confirmPasswordController.text,
          "fcmToken": fcm_token
        };
        Resource resource = await authRepository.signUp(body);
        if (resource.status == STATUS.SUCCESS) {
          registrationSuccessData = resource.data;
          print("Token:${registrationSuccessData!.token}");
          isLoading.value = false;
          showSuccessSnackbar("Success", resource.message ?? "Success");
          //clearFormData();
          Get.toNamed(Routes.VERIFY_OTP_PAGE);
          //Get.offAllNamed(Routes.DRIVER_DETAILS_LISTING);
        } else {
          isLoading.value = false;
          showFailureSnackbar("Failure", resource.message ?? "Failure");
        }
      }
    }
  }

 /* Future getInitialData()async{
    if(await _netWorkStatusChecker.isInternetAvailable()) {
      isInitialLoading.value = true;
     // clearFormData();
      Resource initialDataResource = await authRepository
          .loadSignupInitialData();
      if (initialDataResource.status == STATUS.SUCCESS) {
        isInitialLoading.value = false;
      //  setData(initialDataResource.data);
      } else {
        isInitialLoading.value = false;
        showFailureSnackbar("Failed", initialDataResource.message ?? " Failed");
      }
    }
    else{
      Get.back();
      Get.dialog(const CommonNoInterNetWidget());
    }

  }*/

  Future resendOTP(String type)async{

    if(await _netWorkStatusChecker.isInternetAvailable()) {
      isLoading.value = true;
      var body = {
        "verificationToken": registrationSuccessData!.token ?? ""
      };
      Resource initialDataResource = await authRepository.resendOtp(body, type);
      if (initialDataResource.status == STATUS.SUCCESS) {
        isLoading.value = false;
        showSuccessSnackbar("Success",
            initialDataResource.message ?? "Successfully resend otp");
      } else {
        isLoading.value = false;
        showFailureSnackbar("Failed", initialDataResource.message ?? " Failed");
      }
    }
  }

  clearFormData(){
    isMobileVerified.value = false;
    isEmailVerified.value = false;
    emailController.text ="";
    passwordController.text ="";
    firstNameController.text ="";
    lastNameController.text ="";
    phoneNumberController.text ="";
    addressController.text ="";
    selectedCountryCode.value = "+91";

    selectedLanguage.value =  languageList.first;
    selectedCurrency.value =  currencyList.first;
  }

 /* void setData(RegistrationMasterData data) {
    if(data.countries!=null && data.countries!.isNotEmpty){
      for(var country in data.countries!){
        countryList.add(DropdownModel(uniqueid: country.id!, id: country.id.toString(), label: country.name!));
      }
    }

    if(data.languages!=null && data.languages!.isNotEmpty){
      for(var language in data.languages!){
        languageList.add(DropdownModel(uniqueid: language.id!, id: language.id.toString(), label: language.name!));
      }
    }

    if(data.currencies!=null && data.currencies!.isNotEmpty){
      for(var currency in data.currencies!){
        currencyList.add(DropdownModel(uniqueid: currency.id!, id: currency.id.toString(), label: currency.name!));
      }
    }
  }*/

  void clearTypeSelection(){
    for (var j = 0; j < typeSelectionList.length; j++) {
      typeSelectionList[j].isSelected =  false;
    }
    typeSelectionList.refresh();
  }

  Future getInitialData() async {
    if (await _netWorkStatusChecker.isInternetAvailable()) {
      isInitialLoading.value = true;
      Resource initialDataResource =
      await authRepository.loadSignupInitialData();
      if (initialDataResource.status == STATUS.SUCCESS) {
        isInitialLoading.value = false;
        setData(initialDataResource.data);
      } else {
        isInitialLoading.value = false;
        //showFailureSnackbar("Failed", initialDataResource.message ?? " Failed");
      }
    } else {
      Get.back();
      Get.dialog(const CommonNoInterNetWidget());
    }
  }

  void setData(RegistrationMasterData data) {
    if (data.countries != null && data.countries!.isNotEmpty) {
      countryList.clear();
      countryList.addAll(data.countries!);
    }
  }

  Future verifyMobileOtp()async{
    isMobileVerified.value = false;
    isLoading.value = true;
    if (pinController.text.isNotEmpty && pinController.text.length<5) {
      isLoading.value = false;
      showFailureSnackbar("Oops", "Enter valid otp for mobile no verification");
      return;
    }
    else {
      if (await _netWorkStatusChecker.isInternetAvailable()) {
        var body =
        {
          "verificationToken": registrationSuccessData!.token ?? "",
          "otpCode": pinController.text
        };
        Resource loginResource = await authRepository.userMobileOtpVerification(
            body);
        if (loginResource.status == STATUS.SUCCESS) {
          isMobileVerified.value = true;
          isLoading.value = false;

          showSuccessSnackbar(
              "Success", loginResource.message ?? "Login Success");
          //Get.offAllNamed(Routes.DRIVER_DETAILS_LISTING);
        } else {
          isLoading.value = false;
          showFailureSnackbar(
              "Failed", loginResource.message ?? "Login Failed");
        }
      }
    }
  }

  Future verifyEmailOtp({String? isSkip})async{
    isLoading.value = true;
    if (pinController.text.isNotEmpty && pinController.text.length<5) {
      isLoading.value = false;
      showFailureSnackbar("Oops", "Enter valid otp for mobile no verification");
      return;
    }
    else{
      if(await _netWorkStatusChecker.isInternetAvailable()) {
        var body = {
          "driverType": selectedType?.value,
          "verificationToken": registrationSuccessData!.token ?? "",
          "otpCode": emailPinController.text,
        };
        Resource loginResource = await authRepository.userEmailOtpVerification(
            body);
        if (loginResource.status == STATUS.SUCCESS) {
          isLoading.value = false;
          showSuccessSnackbar(
              "Success", loginResource.message ?? "Registration Success");
         // clearFormData();
          clearFormData();
          sharedPref.setLogindata(jsonEncode(loginResource.data));
          sharedPref.setToken(loginResource.data.token);
          Get.offAllNamed(Routes.DRIVER_DETAILS_LISTING);
        } else {
          isLoading.value = false;
          showFailureSnackbar(
              "Failed", loginResource.message ?? "Registration Failed");
        }
      }
    }
  }

}