import '../../../../core/utils/Resource.dart';
import '../../../map_page_feature/data/models/get_cancel_reasons_response.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../api_client/dashboard_api_client.dart';
import '../models/logout_response_model.dart';



class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardApiClient apiClient;

  DashboardRepositoryImpl({required this.apiClient});

  @override
  Future<Resource> getDashboard({required Map<String, dynamic> header})async {

    return await apiClient.getDashboardData(header: header);
  }
  @override
  Future<Resource> changeOnlineStatus({required Map<String, dynamic> header,required Map<String, dynamic> body})async {

    return await apiClient.changeOnlineStatus(header: header,body: body);
  }
  @override
  Future<GetCancelRideReasonModel> findReasonToCancelRide(Map<String,String> header) async {
    return await apiClient.findReasonToCancelRide(header:header);
  }
  @override
  Future<LogoutResponseModel> logout({required Map<String, dynamic> header,required Map<String, dynamic> body}) async {
    return await apiClient.logout(header:header,body: body);
  }
}
