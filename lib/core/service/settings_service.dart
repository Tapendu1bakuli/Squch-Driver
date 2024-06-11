import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squch_driver/core/utils/app_colors.dart';

class SettingsService extends GetxService {
  Future<SettingsService> init() async {
    return this;
  }

  ThemeData getLightTheme() {
    // TODO change font dynamically
    return ThemeData(
      primaryColor: Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0, foregroundColor: Colors.white),
      brightness: Brightness.light,
      dividerColor: AppColors.colordeepgrey,
      focusColor: AppColors.iconColor,
      hintColor: AppColors.textSubBlack,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: AppColors.colordeepgrey),
      ),
      colorScheme: ColorScheme.light(
        primary: AppColors.buttonColor,
        secondary: AppColors.colorlightgrey,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return AppColors.iconColor;
              }
              return null;
            }),
      ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return null;
                }
                if (states.contains(MaterialState.selected)) {
                  return AppColors.iconColor;
                }
                return null;
              }),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return null;
                }
                if (states.contains(MaterialState.selected)) {
                  return AppColors.iconColor;
                }
                return null;
              }),
          trackColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return null;
                }
                if (states.contains(MaterialState.selected)) {
                  return AppColors.colorWhite;
                }
                return null;
              }),
        )
    );
  }

  ThemeData getDarkTheme() {
    // TODO change font dynamically
    return ThemeData(
        primaryColor: Color(0xFF252525),
        floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0),
        scaffoldBackgroundColor: Color(0xFF2C2C2C),
        brightness: Brightness.dark,
        /*dividerColor:
            Ui.parseColor(setting.value.accentDarkColor, opacity: 0.1),
        focusColor: Ui.parseColor(setting.value.accentDarkColor),
        hintColor: Ui.parseColor(setting.value.secondDarkColor),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Ui.parseColor(setting.value.mainColor)),
        ),
        colorScheme: ColorScheme.dark(
          primary: Ui.parseColor(setting.value.mainDarkColor),
          secondary: Ui.parseColor(setting.value.mainDarkColor),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return Ui.parseColor(setting.value.mainDarkColor);
            }
            return null;
          }),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return Ui.parseColor(setting.value.mainDarkColor);
            }
            return null;
          }),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return Ui.parseColor(setting.value.mainDarkColor);
            }
            return null;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return Ui.parseColor(setting.value.mainDarkColor);
            }
            return null;
          }),
        )*/);
  }

  ThemeMode getThemeMode() {
    return ThemeMode.system;
    /*String? _themeMode = GetStorage().read<String>('theme_mode');
    switch (_themeMode) {
      case 'ThemeMode.light':
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.light
              .copyWith(systemNavigationBarColor: Colors.white),
        );
        return ThemeMode.light;
      case 'ThemeMode.dark':
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark
              .copyWith(systemNavigationBarColor: Colors.black87),
        );
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        if (setting.value.defaultTheme == "dark") {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark
                .copyWith(systemNavigationBarColor: Colors.black87),
          );
          return ThemeMode.dark;
        } else {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light
                .copyWith(systemNavigationBarColor: Colors.white),
          );
          return ThemeMode.light;
        }
    }*/
  }
}
