import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../../../core/network_checker/common_network_checker_controller.dart';
import '../controller/chat_controller/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController(sharedPref: Get.find()));
    Get.lazyPut<CommonNetWorkStatusCheckerController>(() => CommonNetWorkStatusCheckerController(),);
  }
}