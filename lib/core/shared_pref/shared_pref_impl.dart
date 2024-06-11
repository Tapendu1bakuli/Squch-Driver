

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:squch_driver/features/user_auth_feature/data/models/login_response.dart';
import '../../features/user_auth_feature/data/models/login_response.dart';
import '../utils/store_key.dart';
import 'shared_pref.dart';

class SharedPrefImpl extends SharedPref {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Future<bool> isLoggedin() async {
    final SharedPreferences prefs = await _prefs;
    try {
      bool? loggedIn = await prefs.getBool(IS_LOGGED_IN);
      if (loggedIn == null) {
        return false;
      } else {
        return loggedIn;
      }
    } catch (ex) {
      return false;
    }
  }

  Future<bool> isIntroScreenShown() async {
    final SharedPreferences prefs = await _prefs;
    try {
      bool? isIntroShown = await prefs.getBool(INTRO_SCREEN_DISPLAYED);
      if (isIntroShown == null) {
        return false;
      } else {
        return true;
      }
    } catch (ex) {
      return false;
    }
  }

  @override
  Future setIntroScreenShown(bool isLoggedin) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(INTRO_SCREEN_DISPLAYED, isLoggedin);
  }
  @override
  Future setLoggedin(bool isLoggedin) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(IS_LOGGED_IN, isLoggedin);
  }
 @override
  Future setLoggedinIdPassword(String? id,String? password) async {
   final SharedPreferences prefs = await _prefs;
  prefs.setString(LOGIN_ID, id!);
  prefs.setString(LOGIN_PASSWORD, password!);
  }

  @override
  Future clearData() async{
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
  }

  @override
  Future setLogindata(String data) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(USER_DATA, data);
  }

  @override
  Future<LoginData?> getLogindata() async{
    final SharedPreferences prefs = await _prefs;
    String? data="";
    LoginData? userInfo;
    try {
     data = await prefs.getString(USER_DATA);
    // debugPrint("Login Data fetched ======>>>> "+data!);
      if (data == null || data.isEmpty) {
        return null;
      } else {
        Map<String,dynamic> value = json.decode(data);
        userInfo = LoginData.fromJson(value);
        debugPrint("Here ==============>>>>>>>>> "+userInfo!.toJson().toString());
       return userInfo;
      }
    } catch (ex) {
      debugPrint("Here ==============>>>>>>>>> "+ex.toString());
      return userInfo;
    }
  }



  @override
  Future<String> getSelectedLanguage() async{
    final SharedPreferences prefs = await _prefs;
    String? language = prefs.getString(APP_LANGUAGE);
    return language??"en";
  }

  @override
  Future setLanguage(String language) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(APP_LANGUAGE, language);
  }

  @override
  Future<String?> getLoginId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(LOGIN_ID);
  }

  @override
  Future<String?> getLoginPassword() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(LOGIN_PASSWORD);
  }

  @override
  Future setRememberMe(bool data) async{
    final SharedPreferences prefs = await _prefs;
    try {
       await prefs.setBool(REMEMBER_ME, data);
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> isRememberMe() async {
    // TODO: implement rememberMe
    final SharedPreferences prefs = await _prefs;
    try {
      bool? isIntroShown = await prefs.getBool(REMEMBER_ME);
      if (isIntroShown == null) {
        return false;
      } else {
        return true;
      }
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(TOKEN)??"";
  }

  @override
  Future setToken(String token) async{
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(TOKEN, token);
  }

 @override
  Future<String> getFCMToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(FCM_TOKEN)??"";
  }

  @override
  Future setFCMToken(String token) async{
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(FCM_TOKEN, token);
  }

}
