

import '../../../../core/utils/Resource.dart';

abstract class ProfileRepository {

  Future<Resource> getProfile({required Map<String,dynamic> header});
  Future<Resource> getVehicleCompanyList({required Map<String, dynamic> header});
  Future<Resource> getVehicleModelList({required Map<String, dynamic> header, required Map<String, dynamic> body});
  Future<Resource> getBankList({required Map<String, dynamic> header});
  Future<Resource> updateIdProof({required Map<String, dynamic> body, required Map<String, dynamic>headers,required List<String> path,required List<String> key});
  Future<Resource> updateCarDetails({required Map<String, dynamic> body, required Map<String, dynamic>headers, required List<String> path,required List<String> key});
  Future<Resource> updateProfilePicture({required Map<dynamic, dynamic> body, required Map<String, dynamic>headers, required List<String> path,required List<String> key});
  Future<Resource> updateInsuranceDetails({required Map<String, dynamic> body, required Map<String, dynamic>headers, required List<String> path,required List<String> key});
  Future<Resource> updateLicenseDetails({required Map<String, dynamic> body, required Map<String, dynamic>headers, required List<String> path,required List<String> key});
  Future<Resource> updateBankDetails({required Map<String, dynamic> body, required Map<String, dynamic>headers});
}