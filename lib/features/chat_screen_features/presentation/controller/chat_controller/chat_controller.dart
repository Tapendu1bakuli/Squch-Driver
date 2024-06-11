import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:squch_driver/features/dashboard_feature/presentation/controller/dashboard_controller.dart';

import '../../../../../core/apiHelper/api_constant.dart';
import '../../../../../core/service/Socket_Service.dart';
import '../../../../../core/shared_pref/shared_pref.dart';
import '../../../../map_page_feature/presentation/controller/map_controller.dart';
import '../../../data/models/chat_history_model.dart';

class ChatController extends GetxController {
  final ScrollController scrollController = ScrollController();
  TextEditingController chatMessageController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isLoadingAllMessages = false.obs;
  final SharedPref sharedPref;

  ChatController({required this.sharedPref});

  RxBool isOnline = false.obs;
  RxBool chatSendOption = false.obs;
  RxList<Messages> messageList = <Messages>[].obs;
  late MapController mapController;
  late DashboardController dashboardController;

  @override
  void onInit() {
    print("I am good");
    super.onInit();
    mapController = Get.find<MapController>();
    dashboardController = Get.find<DashboardController>();
    chatMessageController.addListener(() {
      if (chatMessageController.text.trim().isEmpty) {
        chatSendOption.value = false;
      } else {
        chatSendOption.value = true;
      }
    });
    fetchMessages(true);
    notifyUserForNewChat();
  }

  void _scrollDown() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  void fetchMessages(bool isCallingFirstTime) {
    if (isCallingFirstTime == true) {
      isLoadingAllMessages.value = true;
    }
    Get.find<SocketService>().emitWithSocket(
        rideFetchMessage, {"tripId": dashboardController.currentTrip.value.id});
    Get.find<SocketService>().listenWithSocket(rideFetchMessage, (data) {
      ChatHistoryModel chatHistoryModel = ChatHistoryModel.fromJson(data);
      print("chatHistoryModel:${chatHistoryModel.toJson()}");
      messageList.clear();
      messageList?.addAll(chatHistoryModel.data?.messages ?? <Messages>[]);
      print("All Messages 1 ${messageList.length}");
      isLoadingAllMessages.value = false;
      _scrollDown();
    });
  }

  void sendMessages() {
    isLoading.value = true;
    Get.find<SocketService>().emitWithSocket(rideSendMessage, {
      "tripId": dashboardController.currentTrip.value.id,
      "message": chatMessageController.text
    });
    Get.find<SocketService>().listenWithSocket(rideSendMessage, (data) {
      print("All Messages $data");
      if (data["status"] == true) {
        isLoading.value = false;
        chatMessageController.clear();
        fetchMessages(false);
      }
    });
  }

  void notifyUserForNewChat() {
    Get.find<SocketService>().listenWithSocket(rideNewMessage, (data) {
      print("All Messages $data");
      fetchMessages(false);
    });
  }
}
