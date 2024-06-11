class LoginResponse {
  bool? status;
  String? message;
  LoginData? data;

  LoginResponse({this.status, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  String? status;
  User? user;
  String? token;

  LoginData({this.status, this.user, this.token});

  LoginData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  int? id;
  int? roleId;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? mobile;
  String? referralCode;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  Role? role;
  String? address;
  String? latitude;
  String? longitude;
  bool? isOnline;
  DriverDocument? driverDocument;

  User(
      {this.id,
      this.roleId,
      this.firstName,
      this.lastName,
      this.email,
      this.countryCode,
      this.mobile,
      this.referralCode,
      this.createdAt,
      this.updatedAt,
      this.profileImage,
      this.role,
      this.address,
      this.latitude,
      this.longitude,
      this.isOnline,
      this.driverDocument});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['roleId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    referralCode = json['referralCode'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    profileImage = json['profileImage'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    address = json['address'];
    latitude = json['latitude'] == null ? "0.0" : json['latitude'].toString();
    longitude =
        json['longitude'] == null ? "0.0" : json['longitude'].toString();
    isOnline = (json['isOnline'].toString() == "1") ? true : false;
    driverDocument = json['driverDocument'] != null
        ? DriverDocument.fromJson(json['driverDocument'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['roleId'] = this.roleId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['countryCode'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['referralCode'] = this.referralCode;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['profileImage'] = this.profileImage;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isOnline'] = this.isOnline == true? "1":"0";
    if (this.driverDocument != null) {
      data['driverDocument'] = this.driverDocument!.toJson();
    }
    return data;
  }
}

class Role {
  int? id;
  String? name;
  String? slug;

  Role({this.id, this.name, this.slug});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class DriverDocument {
  int? id;
  int? userId;
  String? documentStatus;
  String? driveryType;
  IdCardDetails? idCardDetails;
  VehicleDetails? vehicleDetails;
  LicenseDetails? licenseDetails;
  ProfilePicDetails? profilePicDetails;
  InsuranceDetails? insuranceDetails;
  BankDetails? bankDetails;
  String? createdAt;
  String? updatedAt;

  DriverDocument(
      {this.id,
      this.userId,
      this.documentStatus,
      this.driveryType,
      this.idCardDetails,
      this.vehicleDetails,
      this.licenseDetails,
      this.profilePicDetails,
      this.insuranceDetails,
      this.bankDetails,
      this.createdAt,
      this.updatedAt});

  DriverDocument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    documentStatus = json['documentStatus'];
    driveryType = json['driveryType'];
    idCardDetails = json['idCardDetails'] != null
        ? IdCardDetails.fromJson(json['idCardDetails'])
        : null;
    vehicleDetails = json['vehicleDetails'] != null
        ? VehicleDetails.fromJson(json['vehicleDetails'])
        : null;
    licenseDetails = json['licenseDetails'] != null
        ? LicenseDetails.fromJson(json['licenseDetails'])
        : null;
    profilePicDetails = json['profilePicDetails'] != null
        ? ProfilePicDetails.fromJson(json['profilePicDetails'])
        : null;
    insuranceDetails = json['insuranceDetails'] != null
        ? InsuranceDetails.fromJson(json['insuranceDetails'])
        : null;
    bankDetails = json['bankDetails'] != null
        ? BankDetails.fromJson(json['bankDetails'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['documentStatus'] = this.documentStatus;
    data['driveryType'] = this.driveryType;
    if (this.idCardDetails != null) {
      data['idCardDetails'] = this.idCardDetails!.toJson();
    }
    if (this.vehicleDetails != null) {
      data['vehicleDetails'] = this.vehicleDetails!.toJson();
    }
    if (this.licenseDetails != null) {
      data['licenseDetails'] = this.licenseDetails!.toJson();
    }
    if (this.profilePicDetails != null) {
      data['profilePicDetails'] = this.profilePicDetails!.toJson();
    }
    if (this.insuranceDetails != null) {
      data['insuranceDetails'] = this.insuranceDetails!.toJson();
    }
    if (this.bankDetails != null) {
      data['bankDetails'] = this.bankDetails!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class IdCardDetails {
  String? dob;
  String? idCardNumber;
  String? idCardPhoto;
  String? idStatus;
  String? idAdminRemarks;

  IdCardDetails(
      {this.dob,
      this.idCardNumber,
      this.idCardPhoto,
      this.idStatus,
      this.idAdminRemarks});

  IdCardDetails.fromJson(Map<String, dynamic> json) {
    dob = json['dob'];
    idCardNumber = json['idCardNumber'];
    idCardPhoto = json['idCardPhoto'];
    idStatus = json['idStatus'];
    idAdminRemarks = json['idAdminRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dob'] = this.dob;
    data['idCardNumber'] = this.idCardNumber;
    data['idCardPhoto'] = this.idCardPhoto;
    data['idStatus'] = this.idStatus;
    data['idAdminRemarks'] = this.idAdminRemarks;
    return data;
  }
}

class VehicleDetails {
  String? vehicleCompanyId;
  String? vehicleModelId;
  String? vehicleRegYear;
  String? vehicleImage;
  String? vehicleRegDoc;
  String? vehicleStatus;
  String? vehicleAdminRemarks;

  VehicleDetails(
      {this.vehicleCompanyId,
      this.vehicleModelId,
      this.vehicleRegYear,
      this.vehicleImage,
      this.vehicleRegDoc,
      this.vehicleStatus,
      this.vehicleAdminRemarks});

  VehicleDetails.fromJson(Map<String, dynamic> json) {
    vehicleCompanyId = json['vehicleCompanyId'];
    vehicleModelId = json['vehicleModelId'];
    vehicleRegYear = json['vehicleRegYear'];
    vehicleImage = json['vehicleImage'];
    vehicleRegDoc = json['vehicleRegDoc'];
    vehicleStatus = json['vehicleStatus'];
    vehicleAdminRemarks = json['vehicleAdminRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['vehicleCompanyId'] = this.vehicleCompanyId;
    data['vehicleModelId'] = this.vehicleModelId;
    data['vehicleRegYear'] = this.vehicleRegYear;
    data['vehicleImage'] = this.vehicleImage;
    data['vehicleRegDoc'] = this.vehicleRegDoc;
    data['vehicleStatus'] = this.vehicleStatus;
    data['vehicleAdminRemarks'] = this.vehicleAdminRemarks;
    return data;
  }
}

class LicenseDetails {
  String? licenseNumber;
  String? licensePhoto;
  String? licenseStatus;
  String? licenseAdminRemarks;

  LicenseDetails(
      {this.licenseNumber,
      this.licensePhoto,
      this.licenseStatus,
      this.licenseAdminRemarks});

  LicenseDetails.fromJson(Map<String, dynamic> json) {
    licenseNumber = json['licenseNumber'];
    licensePhoto = json['licensePhoto'];
    licenseStatus = json['licenseStatus'];
    licenseAdminRemarks = json['licenseAdminRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['licenseNumber'] = this.licenseNumber;
    data['licensePhoto'] = this.licensePhoto;
    data['licenseStatus'] = this.licenseStatus;
    data['licenseAdminRemarks'] = this.licenseAdminRemarks;
    return data;
  }
}

class ProfilePicDetails {
  String? profilePic;
  String? profilePicStatus;
  String? profilePicAdminRemarks;

  ProfilePicDetails(
      {this.profilePic, this.profilePicStatus, this.profilePicAdminRemarks});

  ProfilePicDetails.fromJson(Map<String, dynamic> json) {
    profilePic = json['profilePic'];
    profilePicStatus = json['profilePicStatus'];
    profilePicAdminRemarks = json['profilePicAdminRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['profilePic'] = this.profilePic;
    data['profilePicStatus'] = this.profilePicStatus;
    data['profilePicAdminRemarks'] = this.profilePicAdminRemarks;
    return data;
  }
}

class InsuranceDetails {
  String? insuranceNumber;
  String? insuranceImage;
  String? insuranceStatus;
  String? insuranceAdminRemarks;

  InsuranceDetails(
      {this.insuranceNumber,
      this.insuranceImage,
      this.insuranceStatus,
      this.insuranceAdminRemarks});

  InsuranceDetails.fromJson(Map<String, dynamic> json) {
    insuranceNumber = json['insuranceNumber'];
    insuranceImage = json['insuranceImage'];
    insuranceStatus = json['insuranceStatus'];
    insuranceAdminRemarks = json['insuranceAdminRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['insuranceNumber'] = this.insuranceNumber;
    data['insuranceImage'] = this.insuranceImage;
    data['insuranceStatus'] = this.insuranceStatus;
    data['insuranceAdminRemarks'] = this.insuranceAdminRemarks;
    return data;
  }
}

class BankDetails {
  String? bankId;
  String? bankBranch;
  String? bankAccNo;
  String? bankIfscCode;
  String? bankStatus;
  String? bankRemarks;

  BankDetails(
      {this.bankId,
      this.bankBranch,
      this.bankAccNo,
      this.bankIfscCode,
      this.bankStatus,
      this.bankRemarks});

  BankDetails.fromJson(Map<String, dynamic> json) {
    bankId = json['bankId']!= null ?json['bankId'].toString():"";
    bankBranch = json['bankBranch'];
    bankAccNo = json['bankAccNo'];
    bankIfscCode = json['bankIfscCode'];
    bankStatus = json['bankStatus'];
    bankRemarks = json['bankRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['bankId'] = this.bankId;
    data['bankBranch'] = this.bankBranch;
    data['bankAccNo'] = this.bankAccNo;
    data['bankIfscCode'] = this.bankIfscCode;
    data['bankStatus'] = this.bankStatus;
    data['bankRemarks'] = this.bankRemarks;
    return data;
  }
}
