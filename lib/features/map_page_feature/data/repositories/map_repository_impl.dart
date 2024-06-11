import '../../../../core/utils/Resource.dart';
import '../../domain/repositories/map_repository.dart';
import '../api_client/map_api_client.dart';


class MapRepositoryImpl extends MapRepository {
  final MapApiClient apiClient;

  MapRepositoryImpl({required this.apiClient});

  @override
  Future<Resource> initRide(Map<String,dynamic>body,Map<String,dynamic>header) async {
    return await apiClient.initRide(body: body,header:header);
  }

  @override
  Future<Resource> changeOnlineStatus({required Map<String, dynamic> header, required Map<String, dynamic> body}) async {
    return await apiClient.changeOnlineStatus(body: body,header:header);
  }

  @override
  Future<Resource> updateLocation({required Map<String, dynamic> header, required Map<String, dynamic> body}) async {
    return await apiClient.updateLocation(body: body,header:header);
  }





}
