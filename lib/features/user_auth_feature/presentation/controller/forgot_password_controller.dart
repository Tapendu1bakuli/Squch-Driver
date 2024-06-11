import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network_checker/common_network_checker_controller.dart';
import '../../../../core/service/page_route_service/routes.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/Resource.dart';
import '../../../../core/utils/Status.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/utils/validator.dart';
import '../../data/models/forget_password_response.dart';
import '../../data/models/registration_success_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../login_page.dart';
import '../verify_registration_otp.dart';
import '../../../../core/network_checker/common_network_checker_controller.dart';
import '../../../../core/network_checker/common_no_network_widget.dart';

class ForgotPasswordController extends GetxController {
  final SharedPref sharedPref;
  final AuthRepository authRepository;

  ForgotPasswordController(
      {required this.sharedPref, required this.authRepository});

  final forgotPasswordFormKey = GlobalKey<FormState>();
  final setNewPasswordFormKey = GlobalKey<FormState>();
  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final CommonNetWorkStatusCheckerController netWorkStatusChecker =
      Get.put(CommonNetWorkStatusCheckerController());

  RxBool isLoading = false.obs;
  RxBool isValidPhoneNo = true.obs;

  RxString phoneValidationMsg = "".obs;
  ForgetPasswordData forgetPasswordData = ForgetPasswordData();
  RxString selectedCountryCode = "+91".obs;


  RxBool isMobileVerified = false.obs;
  RxBool isEmailVerified = false.obs;

  final pinController = TextEditingController();
  final emailPinController = TextEditingController();
  Rx<bool> isPhone = false.obs;

  @override
  void onInit() {
    // Get called when controller is created
    netWorkStatusChecker.updateConnectionStatus();
    emailOrPhoneController.addListener(() {
      if (emailOrPhoneController.text.length > 3) {
        if (!emailOrPhoneController.text.replaceAll("+", "").isNumericOnly) {
          isPhone.value = false;
        } else {
          isPhone.value = true;
          isValidPhoneNo.value = false;
          phoneValidationMsg.value ="Enter a valid Mobile number";
        }
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    // Get called after widget is rendered on the screen
    super.onReady();
  }

  @override
  void onClose() {
    //Get called when controller is removed from memory
    super.onClose();
  }

  Future resendOTP(String type) async {
    if (await netWorkStatusChecker.isInternetAvailable()) {
      isLoading.value = true;
      var body = {"verificationToken": forgetPasswordData!.token ?? ""};
      Resource initialDataResource =
          await authRepository.forgotPasswordResendOtp(body, type);
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

  Future verifyMobileOtp() async {
    isMobileVerified.value = false;
    isLoading.value = true;
    if (pinController.text.isNotEmpty && pinController.text.length < 5) {
      isLoading.value = false;
      showFailureSnackbar("Oops", "Enter valid otp for mobile no verification");
      return;
    } else {
      if (await netWorkStatusChecker.isInternetAvailable()) {
        var body = {
          "verificationToken": forgetPasswordData!.token ?? "",
          "otpCode": pinController.text
        };
        Resource loginResource =
            await authRepository.forgotPasswordVerifyOtp(body, "");
        if (loginResource.status == STATUS.SUCCESS) {
          isLoading.value = false;
          showSuccessSnackbar(
              "Success", loginResource.message ?? "Verify Success");
          Get.toNamed(Routes.SETUP_NEW_PASSWORD);
        } else {
          isLoading.value = false;
          showFailureSnackbar(
              "Failed", loginResource.message ?? "Verify Failed");
        }
      }
    }
  }

  Future verifyEmailOtp() async {
    isLoading.value = true;
    if (pinController.text.isNotEmpty && pinController.text.length < 5) {
      isLoading.value = false;
      showFailureSnackbar("Oops", "Enter valid otp for mobile no verification");
      return;
    } else {
      if (await netWorkStatusChecker.isInternetAvailable()) {
        var body = {
          "verificationToken": forgetPasswordData!.token ?? "",
          "otpCode": emailPinController.text
        };
        Resource loginResource =
            await authRepository.userEmailOtpVerification(body);
        if (loginResource.status == STATUS.SUCCESS) {
          isLoading.value = false;
          showSuccessSnackbar(
              "Success", loginResource.message ?? "Registration Success");
          //clearFormData();
          //Get.offAll(LoginPage());
        } else {
          isLoading.value = false;
          showFailureSnackbar(
              "Failed", loginResource.message ?? "Registration Failed");
        }
      }
    }
  }

  Future forgotPasssword() async {
    if (!forgotPasswordFormKey.currentState!.validate()) {
      return;
    } else {
      if (await netWorkStatusChecker.isInternetAvailable()) {
        isLoading.value = true;
        var body = {"emailormobile": emailOrPhoneController.text};
        Resource resource = await authRepository.forgotPassword(body);
        if (resource.status == STATUS.SUCCESS) {
          isLoading.value = false;
          forgetPasswordData = resource.data;
          showSuccessSnackbar("Success", resource.message ?? "Success");
          Get.toNamed(Routes.FORGOT_PASSWORD_OTP_VERIFICATION);
        } else {
          isLoading.value = false;
          showFailureSnackbar("Failure", resource.message ?? "Failure");
        }
      }
    }
  }

  Future setPasssword() async {
    if (!setNewPasswordFormKey.currentState!.validate()) {
      return;
    } else {
      if (await netWorkStatusChecker.isInternetAvailable()) {
        isLoading.value = true;
        var body = {
          "verificationToken": forgetPasswordData!.token ?? "",
          "newPasword": newPasswordController.text,
          "newPasswordConfirmation": confirmPasswordController.text
        };
        Resource resource = await authRepository.setNewPassword(body);
        if (resource.status == STATUS.SUCCESS) {
          isLoading.value = false;
          showSuccessSnackbar("Success", resource.message ?? "Success");
          Get.offAllNamed(Routes.LOGIN);
        } else {
          isLoading.value = false;
          showFailureSnackbar("Failure", resource.message ?? "Failure");
        }
      }
    }
  }
}
