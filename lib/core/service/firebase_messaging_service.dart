import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../features/dashboard_feature/presentation/controller/dashboard_controller.dart';
import '../../features/user_auth_feature/data/models/login_response.dart';
import '../../features/user_profile_feature/presentation/controller/profile_controller.dart';
import '../shared_pref/shared_pref.dart';
import '../shared_pref/shared_pref_impl.dart';
import 'page_route_service/routes.dart';
class FireBaseMessagingService extends GetxService {
  Future<FireBaseMessagingService> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true);
    messaging.requestPermission(sound: true, badge: true, alert: true);

    await setDeviceToken();
    await fcmOnLaunchListeners();
    await fcmOnResumeListeners();
    await fcmOnMessageListeners();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    return this;
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async{
    print("Handling a background message: ${message?.messageId}");
      //debugPrint("Messege Received ===> "+message.data.toString());
      if (message?.data?.isEmpty??false) {
        _newMessageNotification(message!);
      }
  }

  Future fcmOnMessageListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Messege Received ===> "+message.data.toString());
      if (message.data.isEmpty) {
        _newMessageNotification(message);
      }
      else if (message.data['type'] == "documentVerification") {
        _documentsVerificationNotification(message);
      }else{
        _newMessageNotification(message);
      }
    });
  }
  Future fcmOnLaunchListeners() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    debugPrint("Messege Received Background ===> "+message.toString());
    if (message != null) _notificationsBackground(message);
  }

  Future fcmOnResumeListeners() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notificationsBackground(message);
    });
  }

  void _notificationsBackground(RemoteMessage message) {
    //debugPrint("Messege Received ===> "+message.data.toString());
  /*  if (message.data.isEmpty) {
    }
    else if (message.data['id'] == "App\\Notifications\\NewMessage") {
      _newMessageNotificationBackground(message);
    }
    else if (message.data['id'] ==
        "App\\Notifications\\PromotionNotification") {
      _promotionNotification(message);
    }
    else {
      _newBookingNotificationBackground(message);
    }*/

    if (message.data.isEmpty) {
      _newMessageNotification(message);
    }
    else if (message.data['type'] == "documentVerification") {
      _documentsVerificationNotification(message);
    }else{
      _newMessageNotification(message);
    }
  }


  Future<void> setDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM Token ====>>> $token");
    SharedPref sharedPref =  Get.put(SharedPrefImpl());
    await sharedPref.setFCMToken(token??"");
    /*Get.find<AuthService>().user.value.deviceToken =
        await FirebaseMessaging.instance.getToken();*/
  }


  void _newMessageNotification(RemoteMessage message) {
    RemoteNotification notification = message.notification!;
    createNotification(notificationType: "Generic",title: message.notification?.title??"",message: message.notification?.body??"");

    /*if (Get.find<MessagesController>().initialized) {
      Get.find<MessagesController>().refreshMessages();
    }
    if (Get.currentRoute != Routes.CHAT) {
      Get.showSnackbar(Ui.notificationSnackBar(
        title: notification.title!,
        message: notification.body,
        mainButton: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 42,
          height: 42,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(42)),
            child: AdvanceCacheImage(
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: message.data != null && message.data['icon'] != null
                  ? message.data['icon']
                  : "",
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            ),
          ),
        ),
        onTap: (getBar) async {
          if (message.data['messageId'] != null) {
            Get.back();
            Get.find<RootController>().changePage(2);
          }
        },
      ));
    }*/
  }

  void _documentsVerificationNotification(RemoteMessage message) async{
    SharedPref sharedPref =  Get.put(SharedPrefImpl());
    LoginData? loginData = await sharedPref.getLogindata();
    if(loginData!= null && await sharedPref.isLoggedin()){
      Map<String, dynamic> body = jsonDecode(message.data['data']);

      loginData!.user!.driverDocument!.documentStatus= "approved";
      if(body['allDocumentVerified'] == true){
       sharedPref.setLogindata(jsonEncode(loginData!.toJson()));
        if(Get.currentRoute == Routes.DASHBOARD || Get.currentRoute == Routes.MAP_PAGE ){
         DashboardController controller = Get.find();
         controller.isDocumentsVerified.value = true;
         // controller.getProfile();
       }
       //Get.offAllNamed(Routes.DASHBOARD);
      }else{

      }
      if(Get.currentRoute == Routes.DRIVER_DETAILS_LISTING){
        ProfileController controller = Get.find();
        controller.getProfile();
      }else if(Get.currentRoute == Routes.DASHBOARD || Get.currentRoute == Routes.MAP_PAGE ){
        DashboardController controller = Get.find();
        controller.getProfile();
      }
      createNotification(notificationType: message.data["type"],title: message.notification?.title??"", message: message.notification?.body??"");
    }else{
      //showNotificationSnackbar(title: message.data["documentName"], msg: message.data["documentStatus"]);
    }

  }

  static createNotification({required String notificationType,required String title, required String message}) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
     // new AndroidInitializationSettings('@mipmap/ic_launcher');
     // var initializationSettingsAndroid = const AndroidInitializationSettings('ic_launcher.png'); // <- default icon name is @mipmap/ic_launcher
     // var initializationSettingsIOS = const DarwinInitializationSettings();
    //var initializationSettings = InitializationSettings(android:initializationSettingsAndroid, iOS:initializationSettingsIOS);
    //flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    /*Creating channel for notifications*/
     const AndroidNotificationChannel channel =
    AndroidNotificationChannel('squch_driver', 'squch_driver_channel',
        description: 'quch_driver_notification_channel',
        importance: Importance.high,
        showBadge: true,
        enableVibration: true,
        playSound: true,
    );


     /*Creating notifications details for local notifications*/


    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'squch_driver',
      'squch_driver_channel',
      channelDescription: 'squch_driver_notification_channel',
      importance: Importance.max, // set the importance of the notification
      priority: Priority.high,
      enableVibration: true,
      icon: "@mipmap/ic_launcher",
      // set prority
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

     await flutterLocalNotificationsPlugin
         .resolvePlatformSpecificImplementation<
         AndroidFlutterLocalNotificationsPlugin>()
         ?.createNotificationChannel(channel);
     if(Platform.isAndroid) {
       var platform = NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);

       flutterLocalNotificationsPlugin.show(
           1,
           title,
           message,
           platform);
     }


}

}
