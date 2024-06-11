import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


import '../../../../../core/apiHelper/api_constant.dart';
import '../../../../../core/utils/Resource.dart';
import '../../../../../core/utils/Status.dart';

import '../../../../core/apiHelper/core_service.dart';
import '../../../../core/constant/constant.dart';
import '../../../user_auth_feature/data/models/login_response.dart';
import '../../../user_auth_feature/data/models/registration_success_response.dart';
import '../models/init_ride_response.dart';
import 'map_api_client.dart';

class MapApiClientImpl extends GetConnect implements MapApiClient {
  @override
  void onInit() {
    httpClient.timeout =  const Duration(minutes: TIMEOUT_DURATION);
    httpClient.baseUrl = BASE_URL;
  }

  @override
  Future<Resource> initRide({required Map<String, dynamic> body,required Map<String, dynamic> header}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      header: header,
      endpoint: INIT_RIDE,
    );
    if(response["status"] == true){

      try {
        InitRideResponse initRideResponse = InitRideResponse.fromJson(response);
        return Resource(status: STATUS.SUCCESS, data: initRideResponse.data,message: initRideResponse.message);
      } catch (e) {
        print(e);
        return Resource.error(message: SOMETHING_WENT_WRONG);
      }
    }
    else{
      return Resource(status: STATUS.ERROR, message: response["message"]);
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
      if(response!= null) {
        return Resource(status: STATUS.ERROR, message: response["message"]);
      } else {
        return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
      }
    }
  }
  @override
  Future<Resource> updateLocation({required Map<String, dynamic> header, required Map<String, dynamic> body}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      header: header,
      endpoint: UPDATE_LOCATION,
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



}
