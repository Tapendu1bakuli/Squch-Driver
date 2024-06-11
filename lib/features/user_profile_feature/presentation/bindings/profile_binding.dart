import 'package:get/get.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/shared_pref/shared_pref_impl.dart';
import '../../data/api_client/profile_api_client.dart';
import '../../data/api_client/profile_api_client_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedPref>(
      () => SharedPrefImpl(),
    );
    Get.lazyPut<ProfileApiClient>(
      () => ProfileApiClientImpl(),
    );
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(apiClient: Get.find()),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(profileRepository: Get.find(), sharedPref: Get.find()),
    );
  }
}
