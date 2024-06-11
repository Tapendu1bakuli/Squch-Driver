

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:squch_driver/core/languages/esES.dart';

import '../languages/enUS.dart';
import '../languages/frFR.dart';


class LocalizationService extends Translations{
  // Default locale
  static final locale = Locale('en', 'US');

  // fallbackLocale saves the day when the locale gets in trouble
  static final fallbackLocale = Locale('en', 'US');

  // Supported languages
  // Needs to be same order with locales
  // static final langs = ['English', 'Hindi'];
  static final langs = ['en', 'es','fr'];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('fr','FR')
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS, // lang/en_us.dart
    'es_ES': esES, // lang/tr_tr.dart
    'fr_FR': frFR, // lang/tr_tr.dart
  };

  // Gets locale from language, and updates the locale
  void changeLocale({ required String lang}) {
    final locale = _getLocaleFromLanguage(lang);
    debugPrint(locale!.languageCode);
    Get.updateLocale(locale!);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale? _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }

}