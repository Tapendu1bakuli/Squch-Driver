import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizing/sizing_builder.dart';

import 'core/service/LocalizationService.dart';
import 'core/service/Socket_Service.dart';
import 'core/service/firebase_messaging_service.dart';
import 'core/service/firebase_options.dart';
import 'core/service/page_route_service/app_pages.dart';
import 'core/service/settings_service.dart';
import 'core/shared_pref/shared_pref.dart';
import 'core/shared_pref/shared_pref_impl.dart';
import 'features/welcome_page_feature/presentation/splash_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    // navigation bar color
    statusBarColor: Colors.white,
    systemNavigationBarContrastEnforced: true,
    systemNavigationBarDividerColor: Colors.grey,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await initService();

  runApp(const MyApp());
}

Future initService() async {
  Get.log('starting services ...');
  await Get.putAsync(() => SettingsService().init());
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      name: 'Squch Driver APP',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await Get.putAsync(() => SocketService().initializeSocket());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SizingBuilder(builder: () {
      return GetMaterialApp(
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.AppRoutes,
        debugShowCheckedModeBanner: false,
        translations: LocalizationService(),
        onReady: () async {
          if (Platform.isAndroid) {
            await Get.putAsync(() => FireBaseMessagingService().init());
          }
        },
        locale: Locale('en', 'US'),
        fallbackLocale: Locale('en', 'US'),
        theme: Get.find<SettingsService>().getLightTheme(),
        darkTheme: Get.find<SettingsService>().getDarkTheme(),
        // standard dark theme
        themeMode: Get.find<SettingsService>().getThemeMode(),
        home: const SplashScreen(),
      );
    });
  }
}
