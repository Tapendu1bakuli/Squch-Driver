import '../../../../core/utils/Resource.dart';

abstract class MapRepository {

  Future<Resource> initRide(Map<String,dynamic>body,Map<String,dynamic>header);
  Future<Resource> changeOnlineStatus({required Map<String,dynamic> header,required Map<String, dynamic> body});
  Future<Resource> updateLocation({required Map<String,dynamic> header,required Map<String, dynamic> body});
}