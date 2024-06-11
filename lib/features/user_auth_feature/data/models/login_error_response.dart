class LoginErrorResponse {
  bool? status;
  String? message;
  Data? data;

  LoginErrorResponse({this.status, this.message, this.data});

  LoginErrorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String? status;
  Errors? errors;

  Data({this.status, this.errors});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errors =
    json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.errors != null) {
      data['errors'] = this.errors!.toJson();
    }
    return data;
  }
}

class Errors {
  Email? email;
  Email? password;

  Errors({this.email, this.password});

  Errors.fromJson(Map<String, dynamic> json) {
    email = json['email'] != null ? new Email.fromJson(json['email']) : null;
    password =
    json['password'] != null ? new Email.fromJson(json['password']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.email != null) {
      data['email'] = this.email!.toJson();
    }
    if (this.password != null) {
      data['password'] = this.password!.toJson();
    }
    return data;
  }
}

class Email {
  String? message;
  String? rule;

  Email({this.message, this.rule});

  Email.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    rule = json['rule'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['rule'] = this.rule;
    return data;
  }
}
