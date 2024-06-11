// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_null_comparison

import 'package:get/get.dart';

import '../utils/app_strings.dart';


class Validator {
  String? validateEmail(String? email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (email == null || email.isEmpty)
      return AppStrings.pleaseEnterValidEmailAddress.tr;
    else if (!regex.hasMatch(email))
      return AppStrings.pleaseEnterValidEmailAddress.tr;
    else
      return null;
  }

  String? validatePanNumber(String panNumber) {
    // Regular expression for PAN number validation
    RegExp regex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return regex.hasMatch(panNumber)?null : "Enter valid PAN no";
  }
/*  String? validatePan(String? email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (email == null || email.isEmpty)
      return AppStrings.pleaseEnterValidEmailAddress.tr;
    else if (!regex.hasMatch(email))
      return AppStrings.pleaseEnterValidEmailAddress.tr;
    else
      return null;
  }*/


  String? validatePassword(String? password) {
    /*String pattern =
        r"(^(?=.*[a-z])(?=.*[A-Z])(?=.*[@$!%*?&.*':;€#])[A-Za-z\d@$!%*?&.*':;€#]{6,}$)";
    RegExp regExp = new RegExp(pattern);*/
    if (password == null || password.isEmpty) {
      return AppStrings.pleaseEnterValidPassword.tr;
    } else if (password.length < 8 || password.length > 15) {
      return AppStrings.passwordValid.tr;
    } /*else if (!regExp.hasMatch(password)) {
      return "Must mix numbers, special characters, uppercase and lowercase letters";
    }*/
    return null;
  }

  String? validateConfirmPassword(String? password, String? cPassword) {
    if (cPassword == null || cPassword.isEmpty)
      return AppStrings.pleaseEnterValidPassword.tr;
    else if (cPassword != password)
      return AppStrings.confirmPasswordAlert.tr;
    else
      return null;
  }

  String? textFieldValidation(String value, String msg) {
    String pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-.]';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty)
      return msg;
    else if (regex.hasMatch(value))
      return "Invalid Text";
    else if (value.length < 3)
      return msg;
    else
      return null;
  }

  String? emptyFieldValidation(String value, String msg) {
    String pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-.]';
    RegExp regex = RegExp(pattern);
    print("$regex");
    if (value == null || value.isEmpty)
      return msg;
    else if (value.length < 3)
      return msg;
    else
      return null;
  }

  String? validateMobile(String? value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty)
      return 'Invalid mobile number.';
    else if (!regExp.hasMatch(value))
      return "Invalid mobile number.";
    else if (value.length < 10 && value.length < 15)
      return "Invalid mobile number.";
    else
      return null;
  }

  String? validateOrderId(String value) {
    String pattern = r'(^[0-9a-zA-z-]*$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty)
      return 'Enter OrderId';
    else if (!regExp.hasMatch(value))
      return "Enter valid OrderId";
    else
      return null;
  }

  String? validateEmailAndMobile(String? value) {
    if (value!.isEmpty) {
      return "Enter your email id or mobile number";
    } else if (value.length > 0) {
      if (isNumeric(value)) {
        return validateMobile(value);
      } else {
        return validateEmail(value);
      }
    } else {
      return null;
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    try {
      return double.parse(s) != null;
    } catch (e) {
      print("Error: $e");

      return false;
    }
  }

  bool isValidDate(String input) {
    final date = DateTime.parse(input);
    final originalFormatString = toOriginalFormatString(date);
    return input == originalFormatString;
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }
}
