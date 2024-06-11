import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/features/dashboard_feature/presentation/controller/dashboard_controller.dart';
import 'package:squch_driver/features/map_page_feature/presentation/controller/map_controller.dart';

import '../../../../core/utils/app_colors.dart';

class MapWidget extends GetView<MapController> {
  DashboardController dashboardController;
   MapWidget({super.key, required this.dashboardController});

  @override
  Widget build(BuildContext context) {
    return  CustomGoogleMapMarkerBuilder(
        //screenshotDelay: const Duration(seconds: 4),
        customMarkers: controller.customMarkers ?? <MarkerData>[],
        builder: (BuildContext context, Set<Marker>? markers) {
      return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(controller.currLat, controller.currLong),
        zoom: controller.mapZoomLevel.value,
      ),
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      onMapCreated: controller.onMapCreated,
      polylines: controller.polyline.value,
      padding: EdgeInsets.only(
          top: 20.ss,
          bottom: dashboardController.mapBottomPadding.value),
      markers: markers != null? markers: <Marker>{},
      circles: Set.from([
        Circle(
            circleId: CircleId("id"),
            center: LatLng(controller.currLat, controller.currLong),
            radius: 30,
            fillColor: AppColors.shadowColor,
            strokeColor: AppColors.iconColor.withOpacity(0.5),
            strokeWidth: 1)
      ]),
    );
        });
  }
}
