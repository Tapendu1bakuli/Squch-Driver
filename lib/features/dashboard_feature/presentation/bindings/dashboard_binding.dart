import 'package:get/get.dart';
import 'package:squch_driver/features/user_profile_feature/data/api_client/profile_api_client.dart';
import 'package:squch_driver/features/user_profile_feature/data/api_client/profile_api_client_impl.dart';
import 'package:squch_driver/features/user_profile_feature/data/repositories/profile_repository_impl.dart';
import 'package:squch_driver/features/user_profile_feature/domain/repositories/profile_repository.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/shared_pref/shared_pref_impl.dart';
import '../../../chat_screen_features/presentation/controller/chat_controller/chat_controller.dart';
import '../../../map_page_feature/data/api_client/map_api_client.dart';
import '../../../map_page_feature/data/api_client/map_api_client_impl.dart';
import '../../../map_page_feature/data/repositories/map_repository_impl.dart';
import '../../../map_page_feature/domain/repositories/map_repository.dart';
import '../../../map_page_feature/presentation/bindings/map_binding.dart';
import '../../../map_page_feature/presentation/controller/map_controller.dart';
import '../../data/api_client/dashboard_api_client.dart';
import '../../data/api_client/dashboard_api_client_impl.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedPref>(
      () => SharedPrefImpl(),
    );
    Get.lazyPut<DashboardApiClient>(
      () => DashboardApiClientImpl(),
    );
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(apiClient: Get.find()),
    );
    Get.lazyPut<DashboardController>(
      () => DashboardController(dashboardRepository: Get.find(), sharedPref: Get.find()),
    );
    Get.lazyPut<MapApiClient>(() => MapApiClientImpl(),);
    Get.lazyPut<MapRepository>(() => MapRepositoryImpl(apiClient: Get.find()),);
    Get.lazyPut<MapController>(() => MapController(sharedPref: Get.find(),mapRepository: Get.find()),);
    Get.lazyPut<ProfileApiClient>(() => ProfileApiClientImpl(),);
    Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(apiClient: Get.find()),);
  }
}
