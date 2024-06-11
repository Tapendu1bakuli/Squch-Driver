class RegistrationSuccessResponse {
  bool? status;
  String? message;
  RegistrationSuccessData? data;

  RegistrationSuccessResponse({this.status, this.message, this.data});

  RegistrationSuccessResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new RegistrationSuccessData.fromJson(json['data']) : null;
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

class RegistrationSuccessData {
  String? status;
  String? token;
  String? medium;

  RegistrationSuccessData({this.status, this.token, this.medium});

  RegistrationSuccessData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    medium = json['medium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    data['medium'] = this.medium;
    return data;
  }
}
