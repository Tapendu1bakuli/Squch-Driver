class RegistrationEmailOtpVerificationSuccessResponse {
  bool? status;
  String? message;
  RegistrationEmailOtpVerificationData? data;

  RegistrationEmailOtpVerificationSuccessResponse(
      {this.status, this.message, this.data});

  RegistrationEmailOtpVerificationSuccessResponse.fromJson(
      Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new RegistrationEmailOtpVerificationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class RegistrationEmailOtpVerificationData {
  String? status;
  User? user;
  String? token;

  RegistrationEmailOtpVerificationData({this.status, this.user, this.token});

  RegistrationEmailOtpVerificationData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  int? countryId;
  int? currencyId;
  int? languageId;
  String? createdAt;
  String? updatedAt;
  Role? role;
  Currency? currency;
  Country? country;
  Language? language;

  User(
      {this.id,
        this.roleId,
        this.firstName,
        this.lastName,
        this.email,
        this.countryCode,
        this.mobile,
        this.referralCode,
        this.countryId,
        this.currencyId,
        this.languageId,
        this.createdAt,
        this.updatedAt,
        this.role,
        this.currency,
        this.country,
        this.language});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['roleId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    referralCode = json['referralCode'];
    countryId = json['countryId'];
    currencyId = json['currencyId'];
    languageId = json['languageId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    currency = json['currency'] != null
        ? new Currency.fromJson(json['currency'])
        : null;
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    language = json['language'] != null
        ? new Language.fromJson(json['language'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roleId'] = this.roleId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['countryCode'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['referralCode'] = this.referralCode;
    data['countryId'] = this.countryId;
    data['currencyId'] = this.currencyId;
    data['languageId'] = this.languageId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    if (this.currency != null) {
      data['currency'] = this.currency!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.language != null) {
      data['language'] = this.language!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Currency {
  int? id;
  String? code;
  String? name;
  String? symbol;

  Currency({this.id, this.code, this.name, this.symbol});

  Currency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    return data;
  }
}

class Country {
  int? id;
  String? name;
  String? iso3;
  String? iso2;
  String? phonecode;
  String? flag;

  Country(
      {this.id, this.name, this.iso3, this.iso2, this.phonecode, this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iso3 = json['iso3'];
    iso2 = json['iso2'];
    phonecode = json['phonecode'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['iso3'] = this.iso3;
    data['iso2'] = this.iso2;
    data['phonecode'] = this.phonecode;
    data['flag'] = this.flag;
    return data;
  }
}

class Language {
  int? id;
  String? code;
  String? name;

  Language({this.id, this.code, this.name});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
