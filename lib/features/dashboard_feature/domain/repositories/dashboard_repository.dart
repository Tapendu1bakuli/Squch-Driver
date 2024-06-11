

import '../../../../core/utils/Resource.dart';
import '../../../map_page_feature/data/models/get_cancel_reasons_response.dart';
import '../../data/models/logout_response_model.dart';

abstract class DashboardRepository {
  Future<Resource> getDashboard({required Map<String,dynamic> header});
  Future<Resource> changeOnlineStatus({required Map<String,dynamic> header,required Map<String, dynamic> body});
  Future<GetCancelRideReasonModel> findReasonToCancelRide(Map<String,String> header);
  Future<LogoutResponseModel> logout({required Map<String,dynamic> header,required Map<String, dynamic> body});
}