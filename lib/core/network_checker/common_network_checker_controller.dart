import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:squch_driver/core/utils/utils.dart';

import 'common_no_network_widget.dart';


class CommonNetWorkStatusCheckerController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  var isNetworkAvl = false.obs;

  updateConnectionStatus() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        Get.dialog(const CommonNoInterNetWidget());
      } else {
        isNetworkAvl.value = true;
        bool? isDialogOpen = Get.isDialogOpen;
        if (isDialogOpen == true) {
          Get.back();
        }
      }
    });
  }

  Future<bool>isInternetAvailable() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      // I am connected to a ethernet network.
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      showFailureSnackbar("No Internet", "Your device is not connected with internet.");
      return false;
    }else {
      showFailureSnackbar("No Internet", "Your device is not connected with internet.");
      return false;
    }
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
