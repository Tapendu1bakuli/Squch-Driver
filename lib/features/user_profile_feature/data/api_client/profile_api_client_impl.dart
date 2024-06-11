import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:squch_driver/features/user_auth_feature/data/models/login_response.dart';
import 'package:squch_driver/features/user_profile_feature/data/api_client/profile_api_client.dart';
import 'package:squch_driver/features/user_profile_feature/data/models/bank_list_master_response.dart';

import '../../../../../core/apiHelper/api_constant.dart';
import '../../../../../core/utils/Resource.dart';
import '../../../../../core/utils/Status.dart';

import '../../../../core/apiHelper/core_service.dart';
import '../../../../core/constant/constant.dart';
import '../models/vehicle_company_list_master_response.dart';
import '../models/vehicle_model_list_master_response.dart';



class ProfileApiClientImpl extends GetConnect implements ProfileApiClient {
  @override
  void onInit() {
    httpClient.timeout = const Duration(minutes: TIMEOUT_DURATION);
    httpClient.baseUrl = BASE_URL;
  }


  @override
  Future<Resource> getProfileData({required Map<String, dynamic> header}) async {
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
       if(response!= null) {
         return Resource(status: STATUS.ERROR, message: response["message"]);
       } else {
         return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
       }
    }
  }

  @override
  Future<Resource> getBankList({required Map<String, dynamic> headers}) async {
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: {},
      header: headers,
      endpoint: GET_BANK_LIST,
    );

    if (response!= null && response["status"] == true) {
      try {
        BankListMasterResponse bankListMasterResponse =
        BankListMasterResponse.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: bankListMasterResponse.data!.banks??[],
            message: bankListMasterResponse.message);
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
  Future<Resource> getVehicleCompanyList({required Map<String, dynamic> header}) async{
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: {},
      header: header,
      endpoint: GET_VEHICLE_COMPANY_LIST,
    );

    if (response!= null && response["status"] == true) {
      try {
        VehicleCompanyListMasterResponse vehicleCompanyListMasterResponse =
        VehicleCompanyListMasterResponse.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: vehicleCompanyListMasterResponse.data!.vehicleCompanies??[],
            message: vehicleCompanyListMasterResponse.message);
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
  Future<Resource> getVehicleModelList({required Map<String, dynamic> header,required Map<String, dynamic> body}) async{
    final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: body,
      header: header,
      endpoint: GET_VEHICLE_MODEL_LIST,
    );

    debugPrint(response.toString());
    if (response!= null && response["status"] == true) {
      try {
        VehicleModelListMasterResponse vehicleModelListMasterResponse =
        VehicleModelListMasterResponse.fromJson(response);
        return Resource(
            status: STATUS.SUCCESS,
            data: vehicleModelListMasterResponse.data!.vehicleCompanies,
            message: vehicleModelListMasterResponse.message);
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
  Future<Resource> updateIdProof({required Map<String, dynamic> body, required Map<String, dynamic> headers,required List<String> path,required List<String> key }) async {


    Map<String, String> multipartBody = Map.fromEntries(
      body.entries.where((entry) => entry.value != null).map((entry) {
        return MapEntry(entry.key, entry.value);
      }),
    ); final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.MULTIPART,
      body: multipartBody,
      header: headers,
      endpoint: UPDATE_ID_PROOF,
      fileKeys: key,
      filePath: path
    );

    try {
      if (response != null && response["status"] == true) {
        try {
          LoginResponse updateIdProofResponse =
          LoginResponse.fromJson(response);
          return Resource(
              status: STATUS.SUCCESS,
              data: updateIdProofResponse.data,
              message: updateIdProofResponse.message);
        } catch (e) {
          debugPrint(e.toString());
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      } else {
        if (response != null) {
          return Resource(status: STATUS.ERROR, message: response["message"]);
        } else {
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      }
    }catch(e){
      return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

 @override
  Future<Resource> updateInsuranceDetails({required Map<String, dynamic> body, required Map<String, dynamic> headers,required List<String> path,required List<String> key }) async {


    Map<String, String> multipartBody = Map.fromEntries(
      body.entries.where((entry) => entry.value != null).map((entry) {
        return MapEntry(entry.key, entry.value);
      }),
    ); final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.MULTIPART,
      body: multipartBody,
      header: headers,
      endpoint: UPDATE_INSURANCE_DETAILS,
        fileKeys: key,
        filePath: path
    );
    debugPrint(response.toString());
    try {
      if (response != null && response["status"] == true) {
        try {
          LoginResponse updateIdProofResponse =
          LoginResponse.fromJson(response);
          return Resource(
              status: STATUS.SUCCESS,
              data: updateIdProofResponse.data,
              message: updateIdProofResponse.message);
        } catch (e) {
          debugPrint(e.toString());
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      } else {
        if (response != null) {
          return Resource(status: STATUS.ERROR, message: response["message"]);
        } else {
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      }
    }catch(e){
      return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> updateLicenseDetails({required Map<String, dynamic> body, required Map<String, dynamic> headers, required List<String> path, required List<String> key}) async {

    Map<String, String> multipartBody = Map.fromEntries(
      body.entries.where((entry) => entry.value != null).map((entry) {
        return MapEntry(entry.key, entry.value);
      }),
    ); final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.MULTIPART,
      body: multipartBody,
      header: headers,
      endpoint: UPDATE_LICENSE_DETAILS,
      filePath: path,
      fileKeys: key
    );

    try {
      if (response != null && response["status"] == true) {
        try {
          LoginResponse updateIdProofResponse =
          LoginResponse.fromJson(response);
          return Resource(
              status: STATUS.SUCCESS,
              data: updateIdProofResponse.data,
              message: updateIdProofResponse.message);
        } catch (e) {
          debugPrint(e.toString());
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      } else {
        if (response != null) {
          return Resource(status: STATUS.ERROR, message: response["message"]);
        } else {
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      }
    }catch(e){
      return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> updateBankDetails({required Map<String, dynamic> body, required Map<String, dynamic> headers}) async {
    Map<String, String> multipartBody = Map.fromEntries(
      body.entries.where((entry) => entry.value != null).map((entry) {
        return MapEntry(entry.key, entry.value);
      }),
    ); final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.POST,
      body: multipartBody,
      header: headers,
      endpoint: UPDATE_BANK_DETAILS,
    );

    try {
      if (response != null && response["status"] == true) {
        try {
          LoginResponse updateIdProofResponse =
          LoginResponse.fromJson(response);
          return Resource(
              status: STATUS.SUCCESS,
              data: updateIdProofResponse.data,
              message: updateIdProofResponse.message);
        } catch (e) {
          debugPrint(e.toString());
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      } else {
        if (response != null) {
          return Resource(status: STATUS.ERROR, message: response["message"]);
        } else {
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      }
    }catch(e){
      return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> updateProfilePicture({required Map<dynamic, dynamic> body, required Map<String, dynamic> headers, required List<String> path, required List<String> key}) async {
    Map<String, String> multipartBody = Map.fromEntries(
      body.entries.where((entry) => entry.value != null).map((entry) {
        return MapEntry(entry.key, entry.value);
      }),
    ); final response = await CoreService().apiService(
      baseURL: BASE_URL,
      method: METHOD.MULTIPART,
      body: multipartBody,
      header: headers,
      endpoint: UPDATE_SELFIE,
      fileKeys: key,
      filePath: path
    );

    try {
      if (response != null && response["status"] == true) {
        try {
          LoginResponse updateIdProofResponse =
          LoginResponse.fromJson(response);
          return Resource(
              status: STATUS.SUCCESS,
              data: updateIdProofResponse.data,
              message: updateIdProofResponse.message);
        } catch (e) {
          debugPrint(e.toString());
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      }
      else {
        if (response != null) {
          return Resource(status: STATUS.ERROR, message: response["message"]);
        } else {
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      }
    }catch(e){
      return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

  @override
  Future<Resource> updateCarDetails({required Map body, required Map<String, dynamic> headers, required List<String> path, required List<String> key}) async {
    Map<String, String> multipartBody = Map.fromEntries(
      body.entries.where((entry) => entry.value != null).map((entry) {
        return MapEntry(entry.key, entry.value);
      }),
    );
    final response = await CoreService().apiService(
        baseURL: BASE_URL,
        method: METHOD.MULTIPART,
        body: multipartBody,
        header: headers,
        endpoint: UPDATE_CAR_DETAILS,
        fileKeys: key,
        filePath: path
    );

    try {
      if (response != null && response["status"] == true) {
        try {
          LoginResponse updateIdProofResponse =
          LoginResponse.fromJson(response);
          return Resource(
              status: STATUS.SUCCESS,
              data: updateIdProofResponse.data,
              message: updateIdProofResponse.message);
        } catch (e) {
          debugPrint(e.toString());
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      } else {
        if (response != null) {
          return Resource(status: STATUS.ERROR, message: response["message"]);
        } else {
          return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
        }
      }
    }catch(e){
      return Resource(status: STATUS.ERROR, message: SOMETHING_WENT_WRONG);
    }
  }

}
