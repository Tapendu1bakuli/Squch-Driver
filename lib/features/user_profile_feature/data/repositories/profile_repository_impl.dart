import '../../../../core/utils/Resource.dart';

import '../../domain/repositories/profile_repository.dart';
import '../api_client/profile_api_client.dart';


class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileApiClient apiClient;

  ProfileRepositoryImpl({required this.apiClient});

  @override
  Future<Resource> getProfile({required Map<String, dynamic> header})async {

    return await apiClient.getProfileData(header: header);
  }

  @override
  Future<Resource> updateBankDetails({required Map<String, dynamic> body, required Map<String, dynamic>headers}) async {
   return await apiClient.updateBankDetails(body: body, headers: headers);
  }

  @override
  Future<Resource> updateCarDetails({required Map<String, dynamic> body, required Map<String, dynamic>headers, required List<String> path,required List<String> key}) async{

    return await apiClient.updateCarDetails(headers: headers,body: body,key: key,path: path);
  }


  @override
  Future<Resource> updateIdProof({required Map<String, dynamic> body, required Map<String, dynamic>headers,required List<String> path,required List<String> key}) async {
    return await apiClient.updateIdProof(headers: headers,body: body,key: key,path: path);
  }

  @override
  Future<Resource> updateInsuranceDetails({required Map<String, dynamic> body, required Map<String, dynamic>headers, required List<String> path,required List<String> key}) async{
   return await apiClient.updateInsuranceDetails(body: body, headers: headers, path: path, key: key);
  }

  @override
  Future<Resource> updateProfilePicture({required Map<dynamic, dynamic> body, required Map<String, dynamic>headers, required List<String> path,required List<String> key}) async {
    return await apiClient.updateProfilePicture(body: body, headers: headers, path: path, key: key);
  }


  @override
  Future<Resource> getVehicleCompanyList({required Map<String, dynamic> header}) async {
    return await apiClient.getVehicleCompanyList(header: header);
  }

  @override
  Future<Resource> getVehicleModelList({required Map<String, dynamic> header,required Map<String, dynamic> body}) async {
    return await apiClient.getVehicleModelList(header: header,body: body);
  }

  @override
  Future<Resource> updateLicenseDetails({required Map<String, dynamic> body, required Map<String, dynamic> headers, required List<String> path, required List<String> key}) async {
    return await apiClient.updateLicenseDetails(body: body, headers: headers, path: path, key: key);
  }

  @override
  Future<Resource> getBankList({required Map<String, dynamic> header}) async {
    return await apiClient.getBankList(headers: header);
  }

}
