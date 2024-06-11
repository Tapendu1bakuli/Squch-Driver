import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../core/apiHelper/api_constant.dart';

import '../../../../core/apiHelper/core_service.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/utils/Resource.dart';
import '../../../../core/utils/Status.dart';
import '../../../map_page_feature/data/models/get_cancel_reasons_response.dart';
import '../../../user_auth_feature/data/models/login_response.dart';
import '../models/logout_response_model.dart';
import 'dashboard_api_client.dart';



class DashboardApiClientImpl extends GetConnect implements DashboardApiClient {
  @override
  void onInit() {
    httpClient.timeout = const Duration(minutes: TIMEOUT_DURATION);
    httpClient.baseUrl = BASE_URL;
  }
  @override
  Future<Resource> getDashboardData({required Map<String, dynamic> header}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: {},
      header: header,
      endpoint: GET_PROFILE,
    );

    if (response!= null && response["status"] == true) {
      try {
        LoginResponse profileResponse =
        LoginResponse.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: profileResponse.data,
            message: profileResponse.message);
      } catch (e) {
        debugPrint(e.toString());
        return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
      }
    } else {
      if(response!= null)
        return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> changeOnlineStatus({required Map<String, dynamic> header,required Map<String, dynamic> body}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      header: header,
      endpoint: CHANGE_ONLINE_STATUS,
    );

    if (response!= null && response["status"] == true) {
      try {
        LoginResponse profileResponse =
        LoginResponse.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: profileResponse.data,
            message: profileResponse.message);
      } catch (e) {
        debugPrint(e.toString());
        return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
      }
    } else {
      if(response!= null)
        return Resource(status: STATUS.ERROR, message: response["message"]);
      else return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }
  @override
  Future<GetCancelRideReasonModel> findReasonToCancelRide({required Map<String, String> header}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      header: header,
      endpoint: GET_CANCEL_RIDE_REASON,
    );
    if(response["status"] == true){

      try {
        GetCancelRideReasonModel getCancelRideReasonModel = GetCancelRideReasonModel.fromJson(response);
        return getCancelRideReasonModel;
      } catch (e) {
        print(e);
        return GetCancelRideReasonModel();
      }
    }
    else{
      return GetCancelRideReasonModel();
    }
  }

  @override
  Future<LogoutResponseModel> logout({required Map<String, dynamic> header,required Map<String, dynamic> body}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      header: header,
      endpoint: LOGOUT,
    );

    if (response!= null && response["status"] == true) {
      try {
        LogoutResponseModel logoutResponseModel =
        LogoutResponseModel.fromJson(response);
        return logoutResponseModel;
      } catch (e) {
        debugPrint(e.toString());
        return LogoutResponseModel();
      }
    } else {
      if(response!= null)
        return LogoutResponseModel();
      else return LogoutResponseModel();
    }
  }
}
