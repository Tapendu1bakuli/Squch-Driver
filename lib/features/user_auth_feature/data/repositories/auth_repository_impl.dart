import '../../../../core/utils/Resource.dart';
import '../../domain/repositories/auth_repository.dart';
import '../api_client/auth_api_client.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthApiClient apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
  Future<Resource> userEmailOtpVerification(Map<String,dynamic>body) async {
    return await apiClient.verifyEmailOtp(body: body);
  }

  @override
  Future<Resource> userLogin(String email, String password,String fcmtoken) async {
    var body ={
      "fcmToken":fcmtoken,
      "email":email,
      "password":password
    };
    return await apiClient.userLogin(body: body);
  }


  @override
  Future<Resource> userMobileOtpVerification(Map<String,dynamic>body) async {
    return await apiClient.verifyMobileOtp(body: body);
  }

  @override
  Future<Resource> forgotPassword(Map<String,dynamic>body) async {
    return await apiClient.forgotPassword(body: body);
  }

  @override
  Future<Resource> loadSignupInitialData() async {

    return await apiClient.getPreRegistrationData();
  }

  @override
  Future<Resource> signUp(Map<String, dynamic> body) async{
    return await apiClient.userRegistration(body: body);
  }

  @override
  Future<Resource> resendOtp(Map<String, dynamic> body,String type) async {
    return await apiClient.resendOtp(body: body,type: type);
  }

  @override
  Future<Resource> forgotPasswordResendOtp(Map<String, dynamic> body, String type) async {
    return await apiClient.forgotPasswordResendOtp(body: body,type: type);
  }

  @override
  Future<Resource> forgotPasswordVerifyOtp(Map<String, dynamic> body, String type) async{
    return await apiClient.forgotPasswordVerifyOtp(body: body,type: type);
  }

  @override
  Future<Resource> setNewPassword(Map<String, dynamic> body)async {
    // TODO: implement resetResendOtp
    return await apiClient.setNewPassword(body: body);
  }

}
