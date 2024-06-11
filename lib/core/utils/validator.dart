import 'package:get/get.dart';
import 'package:squch_driver/core/utils/app_strings.dart';

class Validator {
  ///  mobile validation
  String? validateMobile(String? value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp =  RegExp(pattern);
    if (value == null || value.isEmpty) {
      return AppStrings.enterMobileNumber.tr;
    } else if (!regExp.hasMatch(value)) {
      return AppStrings.enterAValidNumber;
    } else if (value.length != 10) {
      return AppStrings.enterAValidMobileNumber;
    } else {
      return null;
    }
  }
  ///  email validation
  String? validateEmail(String? email){
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex =  RegExp(pattern);
    if ( email==null || email.isEmpty) {
      return AppStrings.enterEmailAddress.tr;
    } else if (!regex.hasMatch(email)) {
      return AppStrings.enterValidEmailAddress.tr;
    } else {
      return null;
    }
  }
  ///  password validator
  String? validatePassword(String? value) {
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterPassword.tr;
    } else {
      if (!regex.hasMatch(value)) {
        return AppStrings.passwordValidation.tr;
      } else {
        return null;
      }
    }
  }



  /// confirm password validator
  String? validateConfirmPassword(String? password,String? cPassword){
    if ( cPassword==null || cPassword.isEmpty) {
      return AppStrings.enterConfirmPassword.tr;
    } else if (cPassword!=password) {
      return AppStrings.passwordDoesNotMatch.tr;
    } else {
      return null;
    }
  }

  /// text validation
  String? textFieldValidation(String? value,String? msg){
    String pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-.]' ;
    RegExp regex =  RegExp(pattern);
    if ( value==null || value.isEmpty) {
      return msg??"Enter $msg ";
    } else if (regex.hasMatch(value)) {
      return "Invalid $msg";
    } else if(value.length<3) {
      return "$msg should be more than 3 ";
    } else {
      return null;
    }
  }
}