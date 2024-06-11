import 'package:get/get.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/shared_pref/shared_pref_impl.dart';
import '../../data/api_client/map_api_client.dart';
import '../../data/api_client/map_api_client_impl.dart';
import '../../data/repositories/map_repository_impl.dart';
import '../../domain/repositories/map_repository.dart';
import '../controller/map_controller.dart';




class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedPref>(() => SharedPrefImpl(),);
    Get.lazyPut<MapApiClient>(() => MapApiClientImpl(),);
    Get.lazyPut<MapRepository>(() => MapRepositoryImpl(apiClient: Get.find()),);
    Get.lazyPut<MapController>(() => MapController(sharedPref: Get.find(),mapRepository: Get.find()),);
  }
}
