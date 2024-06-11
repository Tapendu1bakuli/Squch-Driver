


import '../../../../../core/utils/Resource.dart';

abstract class WelcomeApiClient {

  Future<Resource> getIntroData({required Map<String, dynamic> body,required Map<String, dynamic> header});

}