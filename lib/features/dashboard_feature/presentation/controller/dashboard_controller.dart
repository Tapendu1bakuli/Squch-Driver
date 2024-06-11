import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:squch_driver/features/chat_screen_features/presentation/controller/chat_controller/chat_controller.dart';
import 'package:squch_driver/features/dashboard_feature/data/models/new_ride_booking_bid_response.dart';
import 'package:squch_driver/features/dashboard_feature/presentation/controller/map_state.dart';
import 'package:squch_driver/features/dashboard_feature/presentation/controller/ride_state.dart';
import 'package:squch_driver/features/user_profile_feature/data/api_client/profile_api_client.dart';
import 'package:squch_driver/features/user_profile_feature/data/api_client/profile_api_client_impl.dart';
import 'package:squch_driver/features/user_profile_feature/data/repositories/profile_repository_impl.dart';
import 'package:squch_driver/features/user_profile_feature/domain/repositories/profile_repository.dart';
import 'package:squch_driver/features/user_profile_feature/presentation/controller/profile_controller.dart';
import '../../../../config/keys.dart';
import '../../../../core/apiHelper/api_constant.dart';
import '../../../../core/network_checker/common_network_checker_controller.dart';
import '../../../../core/network_checker/common_no_network_widget.dart';
import '../../../../core/service/Socket_Service.dart';
import '../../../../core/service/page_route_service/routes.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/Resource.dart';
import '../../../../core/utils/Status.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/utils.dart';
import '../../../chat_screen_features/data/models/new_message_arrived_model.dart';
import '../../../map_page_feature/data/models/address_model.dart';
import '../../../map_page_feature/data/models/get_cancel_reasons_response.dart';
import '../../../map_page_feature/presentation/controller/map_controller.dart';
import '../../../user_auth_feature/data/models/login_response.dart';
import '../../data/models/logout_response_model.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardController extends GetxController {
  final SharedPref sharedPref;
  final DashboardRepository dashboardRepository;
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;
  RxBool isDocumentsVerified = false.obs;
  RxBool isOnline = false.obs;
  RxBool isInitialLoading = false.obs;
  RxBool isArrived = false.obs;
  RxBool isArrivedAtDestination = false.obs;
  RxBool isRideOTPVerified = false.obs;
  RxBool isDriverArrivedToThePickupPoint = false.obs;
  final pinControllerForRideStart = TextEditingController();
  RxList<CancelReasons>? cancelReasons = <CancelReasons>[].obs;

  RxInt pickupTimerInSec = 0.obs;
  final CommonNetWorkStatusCheckerController _netWorkStatusChecker =
      Get.put(CommonNetWorkStatusCheckerController());
  LoginData? logedinData;
  String? token;

  RxInt counter = 0.obs;
  MapController mapController = Get.find();

  RxList<Trip> tripList = <Trip>[].obs;
  Rx<Trip> currentTrip = Trip().obs;
  RxInt tripDuration = 0.obs;

  RxBool showCancle = false.obs;

  RxString otpValidationError = "".obs;

  DashboardController(
      {required this.sharedPref, required this.dashboardRepository});

  Rx<MapState> mapState = MapState.INITIAL_STATE.obs;
  Rx<MapState> previousState = MapState.INITIAL_STATE.obs;

  RxBool isOtherReasonsTapped = false.obs;
  RxString cancellationReason = "".obs;
  TextEditingController reasonForOtherCancellation = TextEditingController();

  RxDouble mapBottomPadding = 10.0.obs;
  RxDouble bottomSheetMinSize = 0.0.obs;
  RxDouble bottomSheetMaxSize = 0.0.obs;
  RxDouble bottomSheetIntSize = 0.0.obs;

  RxDouble originalPrice = 0.0.obs;
  RxDouble minimumPrice = 0.0.obs;
  RxDouble maximumPrice = 0.0.obs;
  RxString currencySymbol = "".obs;
  RxBool isLimitReachedMaximum = false.obs;
  RxBool isLimitReachedMinimum = false.obs;

/*  Address? source = Address(
      progressStatus: TripTimelineStatus.done,
      description: "San Fransisco station",
      address: "San Fransisco station");
  Address? destination =
      Address(description: "75 Ayer Rajah Cres", address: "75 Ayer Rajah Cres");
  List<Address>? multiStop = <Address>[
    Address(
      description: "75 Ayer Rajah Cres",
      address: "75 Ayer Rajah Cres",
      progressStatus: TripTimelineStatus.inProgress,
    ),
    Address(description: "75 Ayer Rajah Cres", address: "75 Ayer Rajah Cres"),
    Address(description: "75 Ayer Rajah Cres", address: "75 Ayer Rajah Cres")
  ];*/

  @override
  void onInit() {
    super.onInit();
    _netWorkStatusChecker.updateConnectionStatus();
    initLocalData();
  }

  startTimer() {
    Future.delayed(Duration(seconds: 2));
    manageMapState(MapState.BOOKING_ARRIVED);
  }
  RxString newMessage = "".obs;
  RxBool isNewMessageArrived = false.obs;
  void notifyUserForNewChat() {
    Get.find<SocketService>().listenWithSocket(rideNewMessage,
            (data) {
              NewMessageArrivedModel newMessageArrivedModel = NewMessageArrivedModel.fromJson(data);
              print("newMessageArrivedModel:${newMessageArrivedModel.toJson()}");
              print("All Messages 1 ${newMessageArrivedModel.message?.inbox?.tripId}");
              if(newMessageArrivedModel.message?.inbox?.tripId == currentTrip.value.id){
                isNewMessageArrived.value = true;
              }
        });
  }

  Future getDashboard() async {
    logedinData = await sharedPref.getLogindata();
    if (await _netWorkStatusChecker.isInternetAvailable()) {
      isLoading.value = true;
      var header = {"x-access-token": logedinData!.token ?? ""};
      Resource profileResource =
          await dashboardRepository.getDashboard(header: header);
      if (profileResource.status == STATUS.SUCCESS) {
        isLoading.value = false;
        sharedPref.setLogindata(jsonEncode(profileResource.data));
        logedinData = await sharedPref.getLogindata();
      } else {
        isLoading.value = false;
        showFailureSnackbar("Failed", profileResource.message ?? "Failed");
      }
    } else {
      showFailureSnackbar(
          "No Internet", "Your device is not connected with internet.");
    }
  }

  negotiationPriceSetting(
      double minimum, double original, double maximum, bool isIncrease) {
    /*print("ISINCREASE:$isIncrease");
    print("minimum:$minimum");
    print("original:$original");
    print("maximum:$maximum");*/
    if (isIncrease == true) {
      if (originalPrice.value <= maximumPrice.value) {
        originalPrice.value = original + 5;
        original = originalPrice.value;
        //print("Increased Fare:$originalPrice");
      }
      if (originalPrice.value >= maximumPrice.value) {
        isLimitReachedMaximum.value = true;
        isLimitReachedMinimum.value = false;
      } else {
        isLimitReachedMinimum.value = false;
        isLimitReachedMaximum.value = false;
      }
    } else {
      if (originalPrice.value >= minimumPrice.value) {
        originalPrice.value = original - 5;
        original = originalPrice.value;
        //print("Decreased Fare:$originalPrice");
      }
      if (originalPrice.value <= minimumPrice.value) {
        isLimitReachedMinimum.value = true;
        isLimitReachedMaximum.value = false;
      } else {
        isLimitReachedMinimum.value = false;
        isLimitReachedMaximum.value = false;
      }
    }
    isLimitReachedMaximum.refresh();
    isLimitReachedMinimum.refresh();
  }

  Future changeOnlineStatus({required bool status}) async {
    logedinData = await sharedPref.getLogindata();
    token = await sharedPref.getToken();
    if (await _netWorkStatusChecker.isInternetAvailable()) {
      isLoading.value = true;
      var header = {"x-access-token": token ?? ""};
      Resource profileResource =
          await dashboardRepository.changeOnlineStatus(header: header, body: {
        "isOnline": status ? 1 : 0,
        "latitude": mapController.currLat,
        "longitude": mapController.currLong
      });
      if (profileResource.status == STATUS.SUCCESS) {
        isLoading.value = false;
        logedinData = profileResource.data;
        logedinData!.token = token;
        isOnline.value = logedinData?.user?.isOnline ?? false;
        sharedPref.setLogindata(jsonEncode(logedinData!.toJson()));
        logedinData = await sharedPref.getLogindata();
        if (isOnline.isTrue) {
          listeningNewTripsInSocket();
          getInitialTripsFromSocket();
        } else {
          clearAllSocket();
        }
      } else {
        isLoading.value = false;
        showFailureSnackbar("Failed", profileResource.message ?? "Failed");
      }
    } else {
      showFailureSnackbar(
          "No Internet", "Your device is not connected with internet.");
    }
  }

  void initLocalData() async {
    logedinData = await sharedPref.getLogindata();
    token = await sharedPref.getToken();
    isOnline.value = logedinData?.user?.isOnline ?? false;
    isDocumentsVerified.value =
        logedinData?.user?.driverDocument?.documentStatus == "approved"
            ? true
            : false;
    await getProfile();
    getInitialTripsFromSocket();
  }

  Future getProfile() async {
    logedinData = await sharedPref.getLogindata();
    token = await sharedPref.getToken();
    if (await _netWorkStatusChecker.isInternetAvailable()) {
      isInitialLoading.value = true;
      // debugPrint(logedinData.toString());
      var header = {"x-access-token": logedinData!.token ?? ""};

      ProfileRepository profileRepository = Get.find();

      Resource profileResource =
          await profileRepository.getProfile(header: header);
      if (profileResource.status == STATUS.SUCCESS) {
        isLoading.value = false;
        isInitialLoading.value = false;
        logedinData = profileResource.data;
        logedinData!.token = token;
        sharedPref.setLogindata(jsonEncode(logedinData!.toJson()));
        logedinData = await sharedPref.getLogindata();
        isOnline.value = logedinData?.user?.isOnline ?? false;
        isDocumentsVerified.value =
            logedinData?.user?.driverDocument?.documentStatus == "approved"
                ? true
                : false;
        listeningNewTripsInSocket();
      } else {
        isLoading.value = false;
        showFailureSnackbar("Failed", profileResource.message ?? "Failed");
      }
    } else {
      showFailureSnackbar(
          "No Internet", "Your device is not connected with internet.");
    }
  }

  void getInitialTripsFromSocket() {
    if (isOnline.isTrue) {
      Get.find<SocketService>().emitWithSocket(driverRideSearch, {});
      Get.find<SocketService>().listenWithSocket(driverRideSearch,
          (allTripList) {
        print("driverRideSearch: $allTripList");
        tripList.clear();
        RideBookingBidResponse rideBookingBidResponse =
            RideBookingBidResponse.fromJson(allTripList);
        /*RideBookingBidResponse rideBookingBidResponse =
            RideBookingBidResponse.fromJson({
              "status": true,
              "message": "Success",
              "data": {
                "status": "success",
                "settings": {
                  "tripAutoCancelTime": "300",
                  "bidPriceDecAllowed": "10",
                  "bidPriceIncAllowed": "50"
                },
                "trips": [
                  {
                    "id": 959,
                    "customerId": 97,
                    "driverId": null,
                    "vehicleTypeId": 1,
                    "sceLat": "22.9763594",
                    "sceLong": "86.8623378",
                    "sceLocation": "XVG7+92J, Khatra, West Bengal 722140, India",
                    "destLat": "22.6017521",
                    "destLong": "88.38313269999999",
                    "destLocation": "J92M+P72, Kolkata Station Rd, Belgachia, Kolkata, West Bengal 700004, India",
                    "distance": 248699,
                    "initCalcPrice": 1650,
                    "price": 1650,
                    "driverCharges": null,
                    "adminCharges": null,
                    "type": "normal",
                    "status": "pending",
                    "paymentMode": "cash",
                    "currency": "INR",
                    "currencySymbol": "₹",
                    "driverArrivedAt": null,
                    "rideStartedAt": null,
                    "rideCompletedAt": null,
                    "createdAt": "2024-02-13T07:04:32.000Z",
                    "updatedAt": "2024-02-13T07:04:32.000Z",
                    "customer": {
                      "id": 97,
                      "roleId": 4,
                      "subRoleId": 4,
                      "firstName": "Rider",
                      "lastName": "Rides",
                      "email": "rider3@yopmail.com",
                      "countryCode": "+91",
                      "mobile": "7980600826",
                      "referralCode": "C4R7gAiU",
                      "createdAt": "2024-02-06T07:41:49.000Z",
                      "updatedAt": "2024-02-12T07:47:16.000Z",
                      "profileImage": "http://api.squch.com/public/assets/images/user-avatar.png",
                      "rating": "3"
                    },
                    "vehicleType": {
                      "id": 1,
                      "name": "Squch Basic",
                      "image": "http://api.squch.com/public/uploads/masters/vehicletypes/1701169466450_taxi.png",
                      "seatCapacity": 5
                    },
                    "stoppages": [
                      {
                        "id": 1,
                        "tripId": 959,
                        "latitude": "23.060259199999997",
                        "longitude": "86.6614606",
                        "location": "Hatirampur - Manbazar Rd, Manbazar, West Bengal 723131, India",
                        "status": "pending",
                        "reachedAt": null
                      }
                    ],
                    "minDriverPrice": 1485,
                    "maxDriverPrice": 2475,
                    "sceDistance": {
                      "distance": {
                        "text": "197.0 km",
                        "value": 197009
                      },
                      "duration": {
                        "text": "330 mins",
                        "value": 19774
                      }
                    },
                    "destDistance": {
                      "distance": {
                        "text": "248.7 km",
                        "value": 248699
                      },
                      "duration": {
                        "text": "375 mins",
                        "value": 22512
                      }
                    }
                  }
                ]
              }
            });*/
        tripDuration.value = (int.tryParse(
                    rideBookingBidResponse.data?.settings?.tripAutoCancelTime ??
                        "0") ??
                0) *
            1000;
        tripList.addAll(rideBookingBidResponse.data?.trips ?? <Trip>[]);
        if (tripList.isNotEmpty) {
          manageMapState(MapState.BOOKING_ARRIVED);
        } else {
          manageMapState(MapState.INITIAL_STATE);
        }
      });
    } else {
      Get.find<SocketService>().stopListenWithSocket(driverRideSearch);
    }
  }

  void listeningNewTripsInSocket() async {
    if (isOnline.isTrue) {
      Get.find<SocketService>().listenWithSocket(driverSearchRideIn, (data) {
        print("driverSearchRideIn: $data");
        manageMapState(MapState.BOOKING_ARRIVED);
        getInitialTripsFromSocket();
      });
      Get.find<SocketService>().listenWithSocket(driverSearchRideOut, (data) {
        print("driverSearchRideOut: $data");
        getInitialTripsFromSocket();
        if (tripList.isEmpty) {
          manageMapState(MapState.INITIAL_STATE);
        }
      });
    } else {
      Get.find<SocketService>().stopListenWithSocket(driverSearchRideIn);
      Get.find<SocketService>().stopListenWithSocket(driverSearchRideOut);
    }
  }

  void onNegotiationTrip({required Trip trips}) {
    currentTrip.value.update(trip: trips);
    minimumPrice.value = (trips.minDriverPrice ?? 0.0).toDouble();
    maximumPrice.value = (trips.maxDriverPrice ?? 0.0).toDouble();
    originalPrice.value = trips.price?.toDouble() ?? 0;
    currencySymbol.value = trips.currencySymbol ?? "";
    manageMapState(MapState.NEGOTIATION_BOOKING_STATE);
  }

  void onAcceptTrip({required Trip trips}) {
    double originalPriceValue = trips.price?.toDouble() ?? 0;
    currentTrip.value.update(trip: trips);
    minimumPrice.value = (trips.minDriverPrice ?? 0.0).toDouble();
    maximumPrice.value = (trips.maxDriverPrice ?? 0.0).toDouble();
    originalPrice.value = trips.price?.toDouble() ?? 0;
    currencySymbol.value = trips.currencySymbol ?? "";
    manageMapState(MapState.LOADER_STATE);
    print("Price ==>> ${int.tryParse(originalPrice.value.toInt().toString())}");
    trips.price = originalPriceValue.toInt();
    print("Current Price ==>> ${trips.toJson()}");
    Get.find<SocketService>().emitWithSocket(driverRideAccept, trips.toJson());
    Get.find<SocketService>().listenWithSocket(driverRideAccept, (data) {
      print("driverRideAccept: $data");
      if (data['status']) {
        currentTrip.value.update(trip: trips);
        tripList.remove(trips);
      } else {
        manageMapState(MapState.INITIAL_STATE);
        showFailureSnackbar(data['status'], data['message']);
      }
      update();
    });
    Get.find<SocketService>().listenWithSocket(rideStatusUpdate, (data) {
      debugPrint("rideStatusUpdate: $data", wrapWidth: 1024);
      if (data['trip']['status'] == 'confirmed') {
        Trip trip = Trip.fromJson(data['trip']);
        currentTrip.value.update(trip: trip);
        currentTrip.refresh();
        manageMapState(MapState.ACCEPT_BOOKING_STATE);
        notifyUserForNewChat();
      }
      if (data['trip']['status'] == 'cancelled') {
        manageMapState(MapState.INITIAL_STATE);
        Get.find<SocketService>().stopListenWithSocket(rideNewMessage);
        //tripList.remove(trips);
      }
      if (data['trip']['status'] == 'driverarrived') {
        String remainingTime =
            (data['settings']['driverPickupMinWaitTime']) ?? "0";
        pickupTimerInSec.value = int.parse(remainingTime);
        manageMapState(MapState.PICKUP_BOOKING_STATE);
        //tripList.remove(trips);
      }
      if (data['trip']['status'] == 'started') {
        Trip trip = Trip.fromJson(data['trip']);
        currentTrip.value.update(trip: trip);
      }

      /// HANDLE NEW STATUS AFTER STATUS CHANGE FROM USER END

      update();
    });
    Get.find<SocketService>().listenWithSocket(driverRideBidRejected, (data) {
      print("driverRideBidRejected: $data");
      if (data['tripBid']['status'] == 'rejected') {
        manageMapState(MapState.BOOKING_ARRIVED);
        getInitialTripsFromSocket();
      }
      update();
    });
  }

  void clearAllSocket() {
    Get.find<SocketService>().stopListenWithSocket(driverRideSearch);
    Get.find<SocketService>().stopListenWithSocket(driverSearchRideIn);
    Get.find<SocketService>().stopListenWithSocket(driverRideAccept);
    Get.find<SocketService>().stopListenWithSocket(rideStatusUpdate);
    Get.find<SocketService>().stopListenWithSocket(driverRideBidRejected);
    Get.find<SocketService>().stopListenWithSocket(driverSearchRideOut);
  }

  void onTripAnimationEndTime({required Trip trips}) {
    tripList.removeWhere((element) => element.id == trips.id);
  }

  void arrivedPickupPoint() {
    manageMapState(MapState.LOADER_STATE);
    Get.find<SocketService>().emitWithSocket(driverRideStatusUpdate,
        {"tripId": currentTrip.value.id, "status": "arrived"});
    Get.find<SocketService>().listenWithSocketOnce(driverRideStatusUpdate,
        (data) {
      print("arrivedPickupPoint -> driverRideStatusUpdate: $data");
      if (data['status']) {
        Trip trip = Trip.fromJson(data['data']['trip']);
        currentTrip.value.update(trip: trip);
        manageMapState(MapState.PICKUP_BOOKING_STATE);
        //tripList.remove(trips);
      } else {
        manageMapState(MapState.INITIAL_STATE);
        showFailureSnackbar(AppStrings.failed, data['message']);
      }

      update();
    });
  }

  void verifyRiderWithOTP() {
    previousState.value = mapState.value;
    isLoading.value = true;
    otpValidationError.value = "";
    Get.find<SocketService>().emitWithSocket(driverRideStatusUpdate, {
      "tripId": currentTrip.value.id,
      "status": "started",
      "otpCode": pinControllerForRideStart.text
    });
    Get.find<SocketService>().listenWithSocketOnce(driverRideStatusUpdate,
        (data) {
      print("verifyRiderWithOTP -> driverRideStatusUpdate: $data");
      if (data['status']) {
        pinControllerForRideStart.clear();
        isArrived.value = false;
        manageMapState(MapState.VERIFIED_OTP_AND_RIDE_START_STATE);
      } else {
        otpValidationError.value = data['message'];
      }
      isLoading.value = false;
      update();
    });
  }

  verifyAndStartRide() async {
    Future.delayed(Duration(milliseconds: 300), () {
      manageMapState(MapState.REQUEST_CUSTOMER_OTP_FOR_RIDE_START_STATE);
    });
  }

  void findReasonToCancelRide() async {
    if (await _netWorkStatusChecker.isInternetAvailable()) {
      isLoading.value = true;
      Map<String, String> header = {"x-access-token": token.toString()};
      GetCancelRideReasonModel getCancelRideReasonModel =
          await dashboardRepository.findReasonToCancelRide(header);
      if (getCancelRideReasonModel.status ?? false) {
        isLoading.value = false;
        manageMapState(MapState.REASON_TO_CANCEL_RIDE);
        isOtherReasonsTapped.value = false;
        cancelReasons?.clear();
        cancelReasons?.addAll(
            getCancelRideReasonModel.data?.cancelReasons ?? <CancelReasons>[]);
        print("Cancel Ride:${cancelReasons?.length}");
        isLoading.value = false;
      } else {
        isLoading.value = false;
        showFailureSnackbar(
            "Failed", getCancelRideReasonModel.message ?? "Loading Failed");
      }
    } else {
      Get.dialog(const CommonNoInterNetWidget());
    }
  }

  void logout() async {
    Get.back();
    if (await _netWorkStatusChecker.isInternetAvailable()) {
      isLoading.value = true;
      Map<String, String> header = {"x-access-token": token.toString()};
      Map<String, String> body = {"fcmToken": await sharedPref.getFCMToken()};
      LogoutResponseModel logoutResponseModel =
          await dashboardRepository.logout(header: header, body: body);
      if (logoutResponseModel.status ?? false) {
        print("Logout");
        logoutUser();
        Get.offAllNamed(Routes.LOGIN);
        isLoading.value = false;
        showSuccessSnackbar(AppStrings.success.tr,
            logoutResponseModel.message ?? "Loading Failed");
      } else {
        isLoading.value = false;
        showFailureSnackbar(AppStrings.failed.tr,
            logoutResponseModel.message ?? "Loading Failed");
      }
    } else {
      Get.dialog(const CommonNoInterNetWidget());
    }
  }

  void cancelRide(String reason) async {
    Get.find<SocketService>().emitWithSocket(driverRideStatusUpdate, {
      "tripId": currentTrip.value.id.toString(),
      "status": "cancelled",
      "cancelReason": reason
    });
    Get.find<SocketService>().listenWithSocketOnce(driverRideStatusUpdate,
        (data) {
      print("customerCancelRide DATA: $data");
      Get.back();
      manageMapState(MapState.INITIAL_STATE);
      getDashboard();
    });
  }

  completeRide(String reason) async {
    Get.find<SocketService>().emitWithSocket(driverRideStatusUpdate, {
      "tripId": currentTrip.value.id.toString(),
      "status": reason,
    });
    Get.find<SocketService>().listenWithSocketOnce(driverRideStatusUpdate,
        (data) {
      print("customerCancelRide DATA: $data");
      Future.delayed(Duration(milliseconds: 300), () {
        Get.back();
        manageMapState(MapState.INITIAL_STATE);
        Get.toNamed(Routes.RIDE_SUMMARY);
        isArrivedAtDestination.value = false;
        Get.find<SocketService>().stopListenWithSocket(rideNewMessage);
      });
    });
  }

  void manageMapState(MapState status) {
    switch (status) {
      case MapState.INITIAL_STATE:
        bottomSheetIntSize.value = 0.00;
        bottomSheetMinSize.value = 0.00;
        bottomSheetMaxSize.value = 0.95;
        mapBottomPadding.value = 0;
        mapController.updateCamera();

        break;
      case MapState.LOADER_STATE:
        bottomSheetIntSize.value = 0.6;
        bottomSheetMinSize.value = 0.40;
        bottomSheetMaxSize.value = 0.95;
        mapBottomPadding.value = Get.size.height / 2;
        //For recreate marker so that marker can be drag.
        break;
      case MapState.BOOKING_ARRIVED:
        bottomSheetIntSize.value = 0.0;
        bottomSheetMinSize.value = 0.0;
        bottomSheetMaxSize.value = 0.0;
        mapBottomPadding.value = 0;
        mapController.clearCustomMarkers();
        //For recreate marker so that marker can't be drag.

        break;
      case MapState.ACCEPT_BOOKING_STATE:
        bottomSheetIntSize.value = 0.55;
        bottomSheetMinSize.value = 0.4;
        bottomSheetMaxSize.value = 0.95;
        mapBottomPadding.value = Get.size.height * 2 / 5;
        mapController.createMarkerAndPolyLineForDriverToPickupPoint(
            trip: currentTrip.value);
        break;
      case MapState.NEGOTIATION_BOOKING_STATE:
        bottomSheetIntSize.value = 0.72;
        bottomSheetMinSize.value = 0.4;
        bottomSheetMaxSize.value = 0.9;
        mapBottomPadding.value = Get.size.height / 2;
        mapController.createMarkerForCurrentTrip(trip: currentTrip.value);
        break;
      case MapState.REASON_TO_CANCEL_RIDE:
        bottomSheetIntSize.value = 0.5;
        bottomSheetMinSize.value = 0.5;
        bottomSheetMaxSize.value = 0.5;
        mapBottomPadding.value = Get.size.height / 2;
        break;
      case MapState.PICKUP_BOOKING_STATE:
        bottomSheetIntSize.value = 0.4;
        bottomSheetMinSize.value = 0.4;
        bottomSheetMaxSize.value = 0.5;
        mapBottomPadding.value = Get.size.height / 2;
        showCancle.value = false;
        break;
      case MapState.REACHED_TO_DESTINATION:
        bottomSheetIntSize.value = 0.4;
        bottomSheetMinSize.value = 0.4;
        bottomSheetMaxSize.value = 0.4;
        mapBottomPadding.value = Get.size.height * 2 / 3;
        break;
      case MapState.REQUEST_CUSTOMER_OTP_FOR_RIDE_START_STATE:
        bottomSheetIntSize.value = 0.28;
        bottomSheetMinSize.value = 0.28;
        bottomSheetMaxSize.value = 0.28;
        mapBottomPadding.value = Get.size.height * 2 / 3;
        break;
      case MapState.VERIFIED_OTP_AND_RIDE_START_STATE:
        bottomSheetIntSize.value = 0.75;
        bottomSheetMinSize.value = 0.70;
        bottomSheetMaxSize.value = 0.95;
        mapBottomPadding.value = Get.size.height / 2;
        mapController.createMarkerForCurrentTrip(trip: currentTrip.value);
        break;
      case MapState.WANT_TO_CANCEL_RIDE_STATE:
        bottomSheetIntSize.value = 0.32;
        bottomSheetMinSize.value = 0.32;
        bottomSheetMaxSize.value = 0.34;
        mapBottomPadding.value = Get.size.height * 2 / 3;
        break;
      case MapState.TRIP_COMPLETE:
        bottomSheetIntSize.value = 0.0;
        bottomSheetMinSize.value = 0.0;
        bottomSheetMaxSize.value = 0.0;
        mapBottomPadding.value = 0;
        mapController.clearCustomMarkers();
        break;
    }
    mapState.value = status;
    mapState.refresh();
    update();
  }

  void onNegotationSkip({required Trip trips}) {
    getInitialTripsFromSocket();
    if (tripList.isEmpty) {
      manageMapState(MapState.INITIAL_STATE);
    }
  }

  void arrivedToStoppage({required int index}) {
    isLoading.value = true;
    Get.find<SocketService>().emitWithSocket(driverRideStatusUpdate, {
      "tripId": currentTrip.value.id,
      "status": "stopReached",
      "stoppageId": currentTrip.value.stoppages?[index].id
    });
    Get.find<SocketService>().listenWithSocketOnce(driverRideStatusUpdate,
        (data) {
      debugPrint("arrivedToStoppage -> driverRideStatusUpdate: $data",
          wrapWidth: 1024);
      if (data['status']) {
        try {
          //Trip trip = Trip.fromJson(data['data']['trip']);
          //currentTrip.value.update(trip: trip);
        } catch (e) {
          isLoading.value = false;
          showFailureSnackbar(AppStrings.failed, e.toString());
        }
      } else {
        showFailureSnackbar(AppStrings.failed, data['message']);
      }
      isLoading.value = false;
      update();
    });
  }
}
