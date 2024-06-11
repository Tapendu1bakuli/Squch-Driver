class VehicleCompanyListMasterResponse {
  bool? status;
  String? message;
  VehicleCompanyListData? data;

  VehicleCompanyListMasterResponse({this.status, this.message, this.data});

  VehicleCompanyListMasterResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ?  VehicleCompanyListData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class VehicleCompanyListData {
  String? status;
  List<VehicleCompanies>? vehicleCompanies;

  VehicleCompanyListData({this.status, this.vehicleCompanies});

  VehicleCompanyListData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['vehicleCompanies'] != null) {
      vehicleCompanies = <VehicleCompanies>[];
      json['vehicleCompanies'].forEach((v) {
        vehicleCompanies!.add(new VehicleCompanies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.vehicleCompanies != null) {
      data['vehicleCompanies'] =
          this.vehicleCompanies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleCompanies {
  int? id;
  String? name;

  VehicleCompanies({this.id, this.name});

  VehicleCompanies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
