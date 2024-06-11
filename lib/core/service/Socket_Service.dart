import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';


import '../apiHelper/api_constant.dart';
import '../shared_pref/shared_pref.dart';
import '../shared_pref/shared_pref_impl.dart';

class SocketService extends GetxService {
  Socket? socket;
  String token = "";

  Future<SocketService> initializeSocket() async {
    SharedPref sharedPref = SharedPrefImpl();
    token = await sharedPref.getToken();
    log("--------initializeSocket-----------");
    try {
      log("--------initializeSocket Try----------- Token: $token");

      if(token.isNotEmpty){
        //Original
        socket = io(
            SOCKET_URL,
            {
              'transports': [SOCKET_TRANSPORTERS],
              'path':SOCKET_PATH,
              'query': {'x-access-token': token},
              'autoConnect': true,
            });
      }

      log("--------initializeSocket onConnect ${socket?.connected} -----------");

      ///For Log the socket info
      /*  socket.onConnect((_) {
        log("--------initializeSocket Try onConnect $_ -----------");
      });
      socket.onConnectError(
        (_) {
          log("--------initializeSocket Try onConnectError $_ -----------");
        },
      );
      socket.onConnectTimeout((_) {
        log("--------initializeSocket Try onConnectTimeout $_ -----------");
      });

      socket.onDisconnect((_) {
        log("--------initializeSocket Try onDisconnect $_ -----------");
      });
      socket.onclose((_) {
        log("--------initializeSocket Try onClose $_ -----------");
      });
      socket.onConnecting((_) {
        log("--------initializeSocket Try onConnecting $_ -----------");
      });
      socket.onError((_) {
        log("--------initializeSocket Try onError $_ -----------");
      });
      socket.onPing((_) {
        log("--------initializeSocket Try onPing $_ -----------");
      });
      socket.onPong((_) {
        log("--------initializeSocket Try onPong $_ -----------");
      });
      socket.onReconnect((_) {
        log("--------initializeSocket Try onReconnect $_ -----------");
      });
      socket.onReconnectAttempt((_) {
        log("--------initializeSocket Try onReconnectAttempt $_ -----------");
      });
      socket.onReconnectError((_) {
        log("--------initializeSocket Try onReconnectError $_ -----------");
      });
      socket.onReconnectFailed((_) {
        log("--------initializeSocket Try onReconnectFailed $_ -----------");
      });
      socket.onReconnecting((_) {
        log("--------initializeSocket Try onReconnecting $_ -----------");
      });*/
    } catch (e) {
      log("--------initializeSocket Catch $e -----------");
    }
    return this;
  }

  void disconnectSocket() {
    log("--------disconnectSocket-----------");
    socket?.onDisconnect((data) => null);
  }

  Future<void> connectSocket()async {
    log("--------connectSocket-----------");
    if(token.isEmpty){
      await Get.find<SocketService>().initializeSocket();
    }
    socket?.onConnect((data) => null);
  }

  void emitWithSocket(String event, Map data)async {
    try {
      if(socket?.disconnected??true) await connectSocket();

      log("--------emitWithSocket Try connectSocket  -----------\nConnection Status: ${socket?.connected}");

      socket?.emit(event, data);
      log("--------emitWithSocket try emitted-----------\n$event $data");
      disconnectSocket();
      log("--------emitWithSocket Try disconnectSocket -----------");
    } catch (e) {
      log("--------emitWithSocket catch $e -----------\n$event $data");
    }
  }

  void listenWithSocket(String event, dynamic fn)async {
    try {
      log("--------listenWithSocket try $event ----------- \nSocket Disconnected: ${socket?.disconnected}");

      if(socket?.disconnected??true) await connectSocket();

      log("--------listenWithSocket Try connectSocket-----------\nConnection Status: ${socket?.connected}");
      socket?.on(event, fn);
      disconnectSocket();
    } catch (e) {
      log("--------listenWithSocket catch $e -----------\n$event");
    }
  }

  void listenWithSocketOnce(String event, dynamic fn)async {
    try {
      log("--------listenWithSocket try $event ----------- \nSocket Disconnected: ${socket?.disconnected}");
      if(socket?.disconnected??true) await connectSocket();
      log("--------listenWithSocket Try connectSocket-----------\nConnection Status: ${socket?.connected}");
      socket?.once(event, fn);
      disconnectSocket();
    } catch (e) {
      log("--------listenWithSocket catch $e -----------\n$event");
    }
  }

  void stopListenWithSocket(String event)async {
    try {
      log("--------listenWithSocket try $event ----------- \nSocket Disconnected: ${socket?.disconnected}");
      if(socket?.disconnected??true) await connectSocket();
      log("--------listenWithSocket Try connectSocket-----------\nConnection Status: ${socket?.connected}");
      socket?.off(event);
      disconnectSocket();
    } catch (e) {
      log("--------listenWithSocket catch $e -----------\n$event");
    }
  }

}
