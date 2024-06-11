import 'package:get/get.dart';
import 'package:squch_driver/features/welcome_page_feature/data/repositories/welcome_repository_impl.dart';
import 'package:squch_driver/features/welcome_page_feature/domain/repositories/welcome_repository.dart';
import 'package:squch_driver/features/welcome_page_feature/presentation/controller/introduction_controller.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/shared_pref/shared_pref_impl.dart';
import '../../data/api_client/welcome_api_client.dart';
import '../../data/api_client/welcome_api_client_impl.dart';




class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedPref>(() => SharedPrefImpl(),);
    Get.lazyPut<WelcomeApiClient>(() => WelcomeApiClientImpl(),);
    Get.lazyPut<WelcomeRepository>(() => WelcomeRepositoryImpl(apiClient: Get.find()),);
    Get.lazyPut<IntroductionController>(() => IntroductionController(welcomeRepository:Get.find(),sharedPref: Get.find()),);
  }
}
