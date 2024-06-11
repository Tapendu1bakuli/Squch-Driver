


//import 'package:squch_driver/features/user_auth_feature/data/models/login_response.dart';

import '../../features/user_auth_feature/data/models/login_response.dart';

abstract class SharedPref {

  Future<String> getSelectedLanguage();
  Future setLanguage(String language);


  Future<bool> isLoggedin();
  Future setIntroScreenShown(bool isShown);
  Future<bool> isIntroScreenShown();
  Future setLoggedin(bool isLoggedin);
  Future setLogindata(String data);
  Future setToken(String token);
  Future setFCMToken(String token);
  Future setLoggedinIdPassword(String? id, String? password);
  Future<LoginData?> getLogindata();
  Future<String?> getLoginId();
  Future<String> getToken();
  Future<String> getFCMToken();
  Future<String?> getLoginPassword();
  Future setRememberMe(bool remember);
  Future<bool> isRememberMe();

  Future clearData();
}