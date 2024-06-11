import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:squch_driver/features/dashboard_feature/data/models/new_ride_booking_bid_response.dart';
import 'package:squch_driver/features/dashboard_feature/presentation/controller/dashboard_controller.dart';
import 'package:squch_driver/features/map_page_feature/presentation/widgets/end_point_marker.dart';
import '../../../../config/keys.dart';
import '../../../../core/common/common_button.dart';
import '../../../../core/common/common_text_form_field.dart';
import '../../../../core/model/dropdown_model.dart';
import '../../../../core/network_checker/common_network_checker_controller.dart';
import '../../../../core/network_checker/common_no_network_widget.dart';
import '../../../../core/place_service/place_provider.dart';
import '../../../../core/service/LocalizationService.dart';
import '../../../../core/service/page_route_service/routes.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/Resource.dart';
import '../../../../core/utils/Status.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/fonts.dart';
import '../../../../core/utils/image_utils.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/gap.dart';
import '../../../../core/widgets/horizontal_gap.dart';
import '../../../../core/widgets/title_text.dart';
import '../../../dashboard_feature/data/api_client/dashboard_api_client.dart';
import '../../../dashboard_feature/data/api_client/dashboard_api_client_impl.dart';
import '../../../dashboard_feature/data/repositories/dashboard_repository_impl.dart';
import '../../../dashboard_feature/domain/repositories/dashboard_repository.dart';
import '../../../user_auth_feature/data/models/login_response.dart';
import '../../data/models/address_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:sizing/sizing.dart';
import 'dart:typed_data';

import '../../data/models/init_ride_response.dart';
import '../../domain/repositories/map_repository.dart';
import '../widgets/start_point_marker.dart';
import 'ride_status.dart';

class MapController extends GetxController {
  final SharedPref sharedPref;
  final MapRepository mapRepository;
  DraggableScrollableController scrollableController =
      DraggableScrollableController();
  BitmapDescriptor? pinLocationIcon;
  BitmapDescriptor? pinLocationTaxiIcon;
  RxList<MarkerData>? customMarkers = <MarkerData>[].obs;

  MapController({required this.sharedPref, required this.mapRepository});

  RxDouble mapZoomLevel = 14.4746.obs;
  Rx<User?> userData = User().obs;
  RxString userName = "".obs;
  RxString token = "".obs;

  final CommonNetWorkStatusCheckerController _netWorkStatusChecker =
      Get.put(CommonNetWorkStatusCheckerController());
  Timer? _throttle;
  RxList<String> location = <String>[].obs;
  List<String> subText = [];
  List<double> latitude = [];
  List<double> longitude = [];
  double currLat = 0.0;
  double currLong = 0.0;
  late double destLat;
  late double destLong;
  RxBool enableSearch = false.obs;
  RxList<Address> locationList = <Address>[].obs;
  RxList<Address> routeList = <Address>[].obs;
  RxBool isLoading = false.obs;
  RxBool isMapSearchBoxVisible = true.obs;
  RxBool isSourceEnable = true.obs;

  Rx<RideStatus> rideStatus = RideStatus.INITIAL_MAP.obs;

  RxBool isRideDriverSearching = false.obs;
  final MarkerId markerIdPickup = const MarkerId("markerPickup");
  final MarkerId markerIdDestination = const MarkerId("markerDestination");
  final RxSet<Polyline> polyline = Set<Polyline>().obs;
  PolylinePoints polylinePoints = PolylinePoints();

  //MAP Page
  CameraPosition defaultLocation = CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 14.4746,
  );

  final mapController = Completer<GoogleMapController>();
  GoogleMapController? googleMapController;
  var defaultPinTheme;
  var focusedPinTheme;
  var submittedPinTheme;

  @override
  void onInit() {
    getUserData();
    getCurrentPosition();
    _netWorkStatusChecker.updateConnectionStatus();
    getLanguageData();
    pinController.setText("1234");
    defaultPinTheme = PinTheme(
      width: 30.ss,
      height: 30.ss,
      textStyle: TextStyle(
          fontSize: 20.fss,
          color: AppColors.colorWhite,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.buttonColor),
          color: AppColors.buttonColor),
    );

    focusedPinTheme = defaultPinTheme.copyDecorationWith(
        border: Border.all(color: AppColors.colorWhite),
        color: AppColors.buttonColor);

    submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.buttonColor,
      ),
    );

    super.onInit();
  }

  @override
  void onClose() {
    googleMapController?.dispose();
    super.onClose();
  }

  Future<void> getCurrentPosition() async {
    if (routeList.length > 1) {
      routeList.removeAt(1);
    }
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currLat = position.latitude;
      currLong = position.longitude;
      getAddressFromLatLng(position);
      updateCamera();
    }).catchError((e) {
      print(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      material.ScaffoldMessenger.of(Get.context as BuildContext).showSnackBar(
          material.SnackBar(
              content: Text("location_services_are_disabled".tr)));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        material.ScaffoldMessenger.of(Get.context as BuildContext).showSnackBar(
            material.SnackBar(
                content: Text("location_permissions_are_denied".tr)));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      material.ScaffoldMessenger.of(Get.context as BuildContext).showSnackBar(
          material.SnackBar(
              content: Text("location permissions_are_permanently_denied".tr)));
      return false;
    }
    return true;
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      debugPrint(
          'Place:  ${place.street}, ${place.locality}, /*${place.administrativeArea},*/ ${place.postalCode}');
      routeList.insert(
          0,
          Address(
            address:
                '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}',
            description: place.locality,
            latitude: position.latitude,
            longitude: position.longitude,
          ));

      if (routeList.isNotEmpty) {}
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  Rx<DropdownModel> selectedLanguage =
      DropdownModel(label: "English", id: "en", uniqueid: 0, dependentId: "en")
          .obs;

  Future<void> changeLanguage() async {
    await sharedPref.setLanguage(selectedLanguage.value.id);
    LocalizationService().changeLocale(lang: selectedLanguage.value.id);
  }

  void getLocationResults(String input) async {
    final String androidKey = mapApiKey;
    final String iosKey = mapApiKey;
    final apiKey = Platform.isAndroid ? androidKey : iosKey;
    if (input.isEmpty) {
      enableSearch.value = false;
    } else {
      enableSearch.value = true;
      String request =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&location=${currLat}%2C${currLong}&radius=20000&key=$apiKey";
      debugPrint("REQ: $request");
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        locationList.clear();
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        List predictions = parsed['predictions'];
        print(predictions);
        for (int i = 0; i < predictions.length; i++) {
          locationList.add(Address(
              id: parsed['predictions'][i]['place_id'],
              description: parsed['predictions'][i]['description'],
              address: parsed['predictions'][i]['structured_formatting']
                  ['secondary_text']));
          debugPrint(locationList[i].toJson().toString());
        }
      } else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed);
      }
    }
  }

  void getLanguageData() async {
    String? selectdLanguage = await sharedPref.getSelectedLanguage();
    debugPrint("Selected Language ======>> " + selectdLanguage.toString());
  }

  void getUserData() async {
    LoginData? loginData = await sharedPref.getLogindata();
    if (loginData != null) {
      userData.value = loginData.user!;
      token.value = loginData.token!;
      debugPrint("UserData ======>> " + userData.toString());
      debugPrint("Token ======>> " + token.value.toString());
    }
    if (userData.value != null) {
      setData(userData.value!);
    }
  }

  void setData(User userData) {
    userName.value = userData.firstName ?? "";
  }

  // RxList<Charges>? charges ;
  var charges = [].obs;
  RxInt selectedTypeIndex = 0.obs;
  Rx<Charges> selectedCharge = Charges().obs;
  Rx<InitRideData?> initRideData = InitRideData().obs;

  final pinController = TextEditingController();

  void createMarker() {
    clearCustomMarkers();
    customMarkers?.add(MarkerData(
      marker: Marker(
        markerId: markerIdDestination,
        position: LatLng(currLat, currLong),
      ),
      child: Image.asset(ImageUtils.pinBig, height: 32, width: 32),
    ));
    customMarkers?.refresh();
  }

  void onMapCreated(GoogleMapController _controller) async {
    print("MAP Created ");
    googleMapController = _controller;
    if (!mapController.isCompleted) {
      mapController.complete(_controller);
    }
    update();
  }

  getDirections({Trip? trip}) async {
    List<LatLng> polylineCoordinates = [];
    List<PolylineWayPoint> waypoints = [];
    if (trip != null && trip.stoppages != null) {
      for (int i = 0; i < trip.stoppages!.length; i++) {
        waypoints.add(PolylineWayPoint(
            location:
                "${trip?.stoppages?[i].latitude},${trip?.stoppages?[i].longitude}",
            stopOver: true));
      }
    }

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapApiKey,
      PointLatLng(
          routeList.first.latitude ?? 0.0, routeList.first.longitude ?? 0.0),
      PointLatLng(
          routeList.last.latitude ?? 0.0, routeList.last.longitude ?? 0.0),
      wayPoints: waypoints,
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      debugPrint(result.errorMessage);
    }
    polyline.clear();
    polyline.add(Polyline(
      polylineId: const PolylineId("polyline_id"),
      visible: true,
      points: polylineCoordinates,
      color: material.Colors.black,
      width: 2,
    ));
    refresh();
  }

  LatLngBounds getCurrentBounds(LatLng position1, LatLng position2) {
    LatLngBounds bounds;

    try {
      bounds = LatLngBounds(
        northeast: position1,
        southwest: position2,
      );
    } catch (_) {
      bounds = LatLngBounds(
        northeast: position2,
        southwest: position1,
      );
    }

    return bounds;
  }

  double getBoundsZoomLevel(LatLngBounds bounds, material.Size mapDimensions) {
    const double padding = 50.0;
    var worldDimension = Get.size;

    double latRad(lat) {
      var sinValue = sin(lat * pi / 180);
      var radX2 = log((1 + sinValue) / (1 - sinValue)) / 2;
      return max(min(radX2, pi), -pi) / 2;
    }

    double zoom(mapPx, worldPx, fraction) {
      return (log(mapPx / worldPx / fraction) / ln2).floorToDouble();
    }

    var ne = bounds.northeast;
    var sw = bounds.southwest;

    var latFraction = (latRad(ne.latitude) - latRad(sw.latitude)) / pi;

    var lngDiff = ne.longitude - sw.longitude;
    var lngFraction = ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;

    var latZoom =
        zoom(mapDimensions.height, worldDimension.height, latFraction);
    var lngZoom = zoom(mapDimensions.width, worldDimension.width, lngFraction);

    if (latZoom < 0) return lngZoom;
    if (lngZoom < 0) return latZoom;

    return min(latZoom, lngZoom);
  }

  LatLng getCentralLatlng(List<LatLng> geoCoordinates) {
    if (geoCoordinates.length == 1) {
      return geoCoordinates.first;
    }

    double x = 0.0;
    double y = 0.0;
    double z = 0.0;

    for (var geoCoordinate in geoCoordinates) {
      var latitude = geoCoordinate.latitude * pi / 180;
      var longitude = geoCoordinate.longitude * pi / 180;

      x += cos(latitude) * cos(longitude);
      y += cos(latitude) * sin(longitude);
      z += sin(latitude);
    }

    var total = geoCoordinates.length;

    x = x / total;
    y = y / total;
    z = z / total;

    var centralLongitude = atan2(y, x);
    var centralSquareRoot = sqrt(x * x + y * y);
    var centralLatitude = atan2(z, centralSquareRoot);

    return LatLng(centralLatitude * 180 / pi, centralLongitude * 180 / pi);
  }

  Future updateMapToBounds(GoogleMapController? controller, LatLng userLatLong,
      LatLng merchantLatLong) async {
    await Future.delayed(Duration(milliseconds: 50));
    mapZoomLevel.value = getBoundsZoomLevel(
            getCurrentBounds(merchantLatLong, userLatLong),
            material.Size(
              Get.size.width - 40.ss,
              Get.size.height -
                  Get.find<DashboardController>().mapBottomPadding.value -
                  20.ss,
            )) -
        0.2;
    print("Zoom Level = $mapZoomLevel");

    // if (mapZoomLevel < 10) mapZoomLevel.value = mapZoomLevel.value + 1.0;
    // if (mapZoomLeveloomLevel > 15) mapZoomLevel.value = mapZoomLevel.value - 1.0;
    controller?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: getCentralLatlng([merchantLatLong, userLatLong]),
        zoom: mapZoomLevel.value,
      )),
    );
    customMarkers?.refresh();
  }

  updateCamera() {
    var _currentLocation = LatLng(currLat, currLong);
    var _currentPosition = CameraPosition(
      target: _currentLocation,
      zoom: 17,
      tilt: 45,
    );
    print("CAMERA: $currLat,$currLong  ::::: $googleMapController");
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(_currentPosition),
    );
    createMarker();
  }

  void createCustomMarkers() {
    clearCustomMarkers();
    customMarkers?.add(MarkerData(
        marker: Marker(
          markerId: markerIdPickup,
          position: LatLng(routeList.first.latitude ?? 0.0,
              routeList.first.longitude ?? 0.0),
        ),
        child: StartPointMarker(
          description: routeList.first.getDescription.split(",").first,
        )));

    customMarkers?.add(MarkerData(
        marker: Marker(
          markerId: markerIdDestination,
          position: LatLng(
              routeList.last.latitude ?? 0.0, routeList.last.longitude ?? 0.0),
        ),
        child: EndPointMarker(
          description: routeList.last.getDescription.split(",").first,
        )));
    addStopageMarker();
    updateMapToBounds(
      googleMapController!,
      LatLng(routeList.first.latitude ?? 0.0, routeList.first.longitude ?? 0.0),
      LatLng(routeList.last.latitude ?? 0.0, routeList.last.longitude ?? 0.0),
    );
    //customMarkers?.refresh();
  }

  void clearCustomMarkers() {
    customMarkers?.clear();
    polyline.clear();
  }

  void addRoutesData({required int index, required Address address}) {
    routeList.insert(index, address);
    print("ROUTE: ${routeList[index].toJson()}");
    routeList.refresh();
  }

  void createMarkerForCurrentTrip({required Trip trip}) {
    clearCustomMarkers();
    routeList.clear();
    routeList.add(trip.origin ??
        Address(
          address: trip.sceLocation,
          description: trip.sceLocation,
          latitude: double.tryParse(trip.sceLat ?? "0.0"),
          longitude: double.tryParse(trip.sceLong ?? "0.0"),
        ));
    routeList.addAll(trip.stoppages ?? <Address>[]);
    routeList.add(trip.destination ??
        Address(
          address: trip.destLocation,
          description: trip.destLocation,
          latitude: double.tryParse(trip.destLat ?? "0.0"),
          longitude: double.tryParse(trip.destLong ?? "0.0"),
        ));
    createCustomMarkers();
    getDirections(trip: trip);
  }

  void addStopageMarker() {
    if (routeList.length > 2) {
      for (int i = 1; i < routeList.length - 1; i++) {
        customMarkers?.add(MarkerData(
            marker: Marker(
              markerId: MarkerId(i.toString()),
              position: LatLng(
                  routeList[i].latitude ?? 0.0, routeList[i].longitude ?? 0.0),
            ),
            child: Image.asset(ImageUtils.stoppageMarker)));
      }
    }
  }

  void createMarkerAndPolyLineForDriverToPickupPoint({Trip? trip}) async {
    customMarkers?.clear();
    print("Pickup Point => ${trip?.origin?.toJson()}");
    print("Driver Point => ${trip?.driver?.toJson()}");
    debugPrint("Trip data => ${trip?.toJson()}",wrapWidth: 1024);
    customMarkers?.add(MarkerData(
        marker: Marker(
          markerId: markerIdPickup,
          position: LatLng(
              double.tryParse(trip?.driver?.latitude ?? "0.0") ?? 0.0,
              double.tryParse(trip?.driver?.longitude ?? "0.0") ?? 0.0),
        ),
        child: StartPointMarker(
          description: trip?.driver?.address?.split(",").first,
          pin: Image.asset(ImageUtils.carOnMap),
        )));

    customMarkers?.add(MarkerData(
        marker: Marker(
          markerId: markerIdDestination,
          position: LatLng(double.tryParse(trip?.sceLat ?? "0.0") ?? 0.0,
              double.tryParse(trip?.sceLong ?? "0.0") ?? 0.0),
        ),
        child: EndPointMarker(
          description: trip?.sceLocation,
          driverDuration: trip?.sceDistance?.duration?.text,
          pin: Image.asset(ImageUtils.mapPin),
        )));
    routeList.clear();
    routeList.add(Address(
      longitude: double.tryParse(trip?.driver?.longitude??"0.0"),
      latitude: double.tryParse(trip?.driver?.latitude??"0.0"),
      description: trip?.driver?.address,
      address: trip?.driver?.address,
    ));
    routeList.add(Address(
      longitude: double.tryParse(trip?.sceLong ??"0.0"),
      latitude: double.tryParse(trip?.sceLat ??"0.0"),
      description: trip?.sceLocation,
      address: trip?.sceLocation,
    ));
    getDirections();
    await updateMapToBounds(
      googleMapController,
      LatLng(double.tryParse(trip?.driver?.latitude ?? "0.0") ?? 0.0,
          double.tryParse(trip?.driver?.longitude ?? "0.0") ?? 0.0),
      LatLng(double.tryParse(trip?.sceLat ?? "0.0") ?? 0.0,
          double.tryParse(trip?.sceLong ?? "0.0") ?? 0.0),
    );
    customMarkers?.refresh();
  }
}
