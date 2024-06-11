import '../../../../../core/utils/Resource.dart';
import '../../../map_page_feature/data/models/get_cancel_reasons_response.dart';
import '../models/logout_response_model.dart';

abstract class DashboardApiClient {
  Future<Resource> getDashboardData({required Map<String, dynamic> header});
  Future<Resource> changeOnlineStatus({required Map<String, dynamic> header,required Map<String, dynamic> body});
  Future<GetCancelRideReasonModel> findReasonToCancelRide({required Map<String, String> header});
  Future<LogoutResponseModel> logout({required Map<String, dynamic> header,required Map<String, dynamic> body});
}