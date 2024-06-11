

import '../../../../core/utils/Resource.dart';

abstract class AuthRepository {

  Future<Resource> userLogin(String email, String password,String fcmToken);
  Future<Resource> resendOtp(Map<String,dynamic>body,String type);
  Future<Resource> loadSignupInitialData();
  Future<Resource> signUp(Map<String,dynamic>body);

  Future<Resource> userEmailOtpVerification(Map<String,dynamic>body);
  Future<Resource> userMobileOtpVerification(Map<String,dynamic>body);

  Future<Resource> forgotPassword(Map<String,dynamic>body);
  Future<Resource> forgotPasswordVerifyOtp(Map<String,dynamic>body,String type);
  Future<Resource> forgotPasswordResendOtp(Map<String,dynamic>body,String type);
  Future<Resource> setNewPassword(Map<String,dynamic>body);

}