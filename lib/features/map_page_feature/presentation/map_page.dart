import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/utils/app_colors.dart';
import 'package:squch_driver/core/utils/image_utils.dart';
import 'package:squch_driver/features/dashboard_feature/presentation/controller/dashboard_controller.dart';
import 'package:squch_driver/features/map_page_feature/presentation/widgets/map_widget.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'controller/map_controller.dart';

class MapPage extends GetView<MapController> {
  MapController controller =
      Get.put(MapController(mapRepository: Get.find(), sharedPref: Get.find()));
  DashboardController _dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return  Animarker(
        curve: Curves.bounceOut,
        rippleRadius: 0.2,
        rippleColor: AppColors.buttonColor,
        useRotation: false,
        duration: const Duration(milliseconds: 100),
        //markers: Set<Marker>.of(controller.markers.value.values),
        mapId: controller.mapController.future
            .then<int>((value) => value.mapId),
        child:
        Obx(() => controller.customMarkers?.isEmpty ?? false
            ? MapWidget(dashboardController: _dashboardController)
            : MapWidget(dashboardController: _dashboardController)),
    );
  }
}


