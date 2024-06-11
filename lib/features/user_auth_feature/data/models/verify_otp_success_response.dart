class VerifyOtpSuccessResponse {
  bool? status;
  String? message;
  VerifyOtpData? data;

  VerifyOtpSuccessResponse({this.status, this.message, this.data});

  VerifyOtpSuccessResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new VerifyOtpData.fromJson(json['data']) : null;
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

class VerifyOtpData {
  String? status;
  String? token;
  String? medium;

  VerifyOtpData({this.status, this.token, this.medium});

  VerifyOtpData.fromJson(Map<String, dynamic> json) {
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
