


import '../../../../../core/utils/Resource.dart';

abstract class MapApiClient {

  Future<Resource> initRide({required Map<String, dynamic> body,required Map<String, dynamic> header});
  Future<Resource> changeOnlineStatus({required Map<String, dynamic> header,required Map<String, dynamic> body});
  Future<Resource> updateLocation({required Map<String, dynamic> header,required Map<String, dynamic> body});
}