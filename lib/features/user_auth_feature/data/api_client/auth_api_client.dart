import '../../../../../core/utils/Resource.dart';

abstract class AuthApiClient {

  Future<Resource> userLogin({required Map<String, dynamic> body});
  Future<Resource> getPreRegistrationData();
  Future<Resource> resendOtp({required Map<String, dynamic> body,required String type});
  Future<Resource> userRegistration({required Map<String, dynamic> body});
  Future<Resource> verifyEmailOtp({required Map<String, dynamic> body});
  Future<Resource> verifyMobileOtp({required Map<String, dynamic> body});
  Future<Resource> forgotPassword({required Map<String, dynamic> body});
  Future<Resource> forgotPasswordVerifyOtp({required Map<String,dynamic>body,required String type});
  Future<Resource> forgotPasswordResendOtp({required Map<String,dynamic>body,required String type});
  Future<Resource> setNewPassword({required Map<String,dynamic>body});
}