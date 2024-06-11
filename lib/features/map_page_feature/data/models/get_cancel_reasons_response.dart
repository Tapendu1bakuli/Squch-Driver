class GetCancelRideReasonModel {
  bool? status;
  String? message;
  Data? data;

  GetCancelRideReasonModel({this.status, this.message, this.data});

  GetCancelRideReasonModel.fromJson(Map<String, dynamic> json) {
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
  List<CancelReasons>? cancelReasons;

  Data({this.status, this.cancelReasons});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['cancelReasons'] != null) {
      cancelReasons = <CancelReasons>[];
      json['cancelReasons'].forEach((v) {
        cancelReasons!.add(new CancelReasons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.cancelReasons != null) {
      data['cancelReasons'] =
          this.cancelReasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CancelReasons {
  int? id;
  String? reason;
  String? icon;

  CancelReasons({this.id, this.reason, this.icon});

  CancelReasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reason'] = this.reason;
    data['icon'] = this.icon;
    return data;
  }
}
