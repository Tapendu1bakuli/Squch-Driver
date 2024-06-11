class VehicleModelListMasterResponse {
  bool? status;
  String? message;
  VehicleModelListData? data;

  VehicleModelListMasterResponse({this.status, this.message, this.data});

  VehicleModelListMasterResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ?  VehicleModelListData.fromJson(json['data']) : null;
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

class VehicleModelListData {
  String? status;
  List<VehicleModels>? vehicleCompanies;

  VehicleModelListData({this.status, this.vehicleCompanies});

  VehicleModelListData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['vehicleCompanies'] != null) {
      vehicleCompanies = <VehicleModels>[];
      json['vehicleCompanies'].forEach((v) {
        vehicleCompanies!.add( VehicleModels.fromJson(v));
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

class VehicleModels {
  int? id;
  int? vehicleCompanyId;
  String? name;
  VehicleCompany? vehicleCompany;

  VehicleModels(
      {this.id, this.vehicleCompanyId, this.name, this.vehicleCompany});

  VehicleModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleCompanyId = json['vehicleCompanyId'];
    name = json['name'];
    vehicleCompany = json['vehicleCompany'] != null
        ? new VehicleCompany.fromJson(json['vehicleCompany'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicleCompanyId'] = this.vehicleCompanyId;
    data['name'] = this.name;
    if (this.vehicleCompany != null) {
      data['vehicleCompany'] = this.vehicleCompany!.toJson();
    }
    return data;
  }
}

class VehicleCompany {
  int? id;
  String? name;

  VehicleCompany({this.id, this.name});

  VehicleCompany.fromJson(Map<String, dynamic> json) {
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
