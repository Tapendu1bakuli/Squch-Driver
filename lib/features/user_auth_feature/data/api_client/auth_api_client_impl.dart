import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../core/apiHelper/api_constant.dart';
import '../../../../../core/utils/Resource.dart';
import '../../../../../core/utils/Status.dart';

import '../../../../core/apiHelper/core_service.dart';
import '../../../../core/constant/constant.dart';
import '../models/forget_password_response.dart';
import '../models/login_response.dart';
import '../models/registration_email_otp_verification_success_response.dart';
import '../models/registration_master_data_model.dart';
import '../models/registration_success_response.dart';
import '../models/verify_otp_success_response.dart';
import 'auth_api_client.dart';

class AuthApiClientImpl extends GetConnect implements AuthApiClient {
  @override
  void onInit() {
    httpClient.timeout = const Duration(minutes: TIMEOUT_DURATION);
    httpClient.baseUrl = BASE_URL;
  }

  @override
  Future<Resource> userLogin({required Map<String, dynamic> body}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      endpoint: LOGIN,
    );
    if (response!= null && response["status"] == true) {
      /*  if (response is LoginResponse ) {
        return Resource(status: STATUS.SUCCESS,data: response.data, message: response.message);
      }else{
      return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }*/

      try {
        LoginResponse loginSuccessResponse = LoginResponse.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS, data: loginSuccessResponse.data);
      } catch (e) {
        print(e);
        return Resource.error(message: SOMETHING_WENT_WRONG);
      }
    } else {
       if(response!= null)
      return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> verifyEmailOtp({required Map<String, dynamic> body}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      endpoint: REGISTRATION_VERIFY_EMAIL,
    );
    debugPrint(response.toString());
    if (response!= null && response["status"] == true) {
      try {
        RegistrationEmailOtpVerificationSuccessResponse
            verifyOtpSuccessResponse =
            RegistrationEmailOtpVerificationSuccessResponse.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: verifyOtpSuccessResponse.data,
            message: verifyOtpSuccessResponse.message);
      } catch (e) {
        debugPrint(e.toString());
        return Resource.error(message: SOMETHING_WENT_WRONG);
      }
    } else {
       if(response!= null)
      return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> verifyMobileOtp({required Map<String, dynamic> body}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      endpoint: REGISTRATION_VERIFY_MOBILE,
    );
    debugPrint(response.toString());
    if (response!= null && response["status"] == true) {
      try {
        VerifyOtpSuccessResponse verifyOtpSuccessResponse =
            VerifyOtpSuccessResponse.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: verifyOtpSuccessResponse.data,
            message: verifyOtpSuccessResponse.message);
      } catch (e) {
        debugPrint(e.toString());
        return Resource.error(message: SOMETHING_WENT_WRONG);
      }
    } else {
       if(response!= null)
      return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> forgotPassword({required Map<String, dynamic> body}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      endpoint: FORGOT_PASSWORD,
    );
    if (response!= null && response["status"] == true) {
      try {
        ForgetPasswordResponse forgetPasswordResponse =
        ForgetPasswordResponse.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: forgetPasswordResponse.data,
            message: forgetPasswordResponse.message);
      } catch (e) {
        debugPrint(e.toString());
        return Resource.error(message: SOMETHING_WENT_WRONG);
      }
    } else {
       if(response!= null)
      return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> userRegistration(
      {required Map<String, dynamic> body}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      endpoint: REGISTRATION_SUBMIT,
    );
    if (response!= null && response["status"] == true) {
      try {
        RegistrationSuccessResponse registrationSuccessResponse =
            RegistrationSuccessResponse.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: registrationSuccessResponse.data,
            message: registrationSuccessResponse.message);
      } catch (e) {
        print(e);
        return Resource.error(message: SOMETHING_WENT_WRONG);
      }
    } else {
       if(response!= null)
      return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> getPreRegistrationData() async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: {},
      endpoint: REGISTRATION_MASTER,
    );

    if (response!= null && response["status"] == true) {
      try {
        RegistrationMasterDataModel registrationMasterDataModel =
            RegistrationMasterDataModel.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: registrationMasterDataModel.data,
            message: registrationMasterDataModel.message);
      } catch (e) {
        debugPrint(e.toString());
        return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
      }
    } else {
       if(response!= null)
      return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> resendOtp(
      {required Map<String, dynamic> body, required String type}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      endpoint: type == "MOBILE" ? RESEND_MOBILE_OTP : RESEND_EMAIL_OTP,
    );

    if (response!= null && response["status"] == true) {
      try {
        //RegistrationMasterDataModel registrationMasterDataModel = RegistrationMasterDataModel.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: response["message"],
            message: response["message"]);
      } catch (e) {
        debugPrint(e.toString());
        return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
      }
    } else {
       if(response!= null)
      return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> forgotPasswordResendOtp(
      {required Map<String, dynamic> body, required String type}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      endpoint: FORGOT_PASSWORD_RESEND_OTP,
    );

    if (response!= null && response["status"] == true) {
      try {
        //RegistrationMasterDataModel registrationMasterDataModel = RegistrationMasterDataModel.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: response["message"],
            message: response["message"]);
      } catch (e) {
        debugPrint(e.toString());
        return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
      }
    } else {
       if(response!= null)
      return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> forgotPasswordVerifyOtp(
      {required Map<String, dynamic> body, required String type}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      endpoint: FORGOT_PASSWORD_VERIFY_OTP,
    );

    if (response!= null && response["status"] == true) {
      try {
        //RegistrationMasterDataModel registrationMasterDataModel = RegistrationMasterDataModel.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: response["message"],
            message: response["message"]);
      } catch (e) {
        debugPrint(e.toString());
        return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
      }
    } else {
       if(response!= null)
      return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> setNewPassword(
      {required Map<String, dynamic> body}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      endpoint: SET_NEW_PASSWORD,
    );

    if (response!= null && response["status"] == true) {
      try {
        //RegistrationMasterDataModel registrationMasterDataModel = RegistrationMasterDataModel.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: response["message"],
            message: response["message"]);
      } catch (e) {
        debugPrint(e.toString());
        return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
      }
    } else {
       if(response!= null)
      return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }
}
