class ChatHistoryModel {
  bool? status;
  String? message;
  Data? data;

  ChatHistoryModel({this.status, this.message, this.data});

  ChatHistoryModel.fromJson(Map<String, dynamic> json) {
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
  List<Messages>? messages;

  Data({this.status, this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int? id;
  int? inboxId;
  int? userId;
  String? senderType;
  String? message;
  String? createdAt;
  String? updatedAt;
  User? user;

  Messages(
      {this.id,
        this.inboxId,
        this.userId,
        this.senderType,
        this.message,
        this.createdAt,
        this.updatedAt,
        this.user});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inboxId = json['inboxId'];
    userId = json['userId'];
    senderType = json['senderType'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['inboxId'] = this.inboxId;
    data['userId'] = this.userId;
    data['senderType'] = this.senderType;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  int? roleId;
  int? subRoleId;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? mobile;
  String? referralCode;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? rating;

  User(
      {this.id,
        this.roleId,
        this.subRoleId,
        this.firstName,
        this.lastName,
        this.email,
        this.countryCode,
        this.mobile,
        this.referralCode,
        this.createdAt,
        this.updatedAt,
        this.profileImage,
        this.rating});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['roleId'];
    subRoleId = json['subRoleId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    referralCode = json['referralCode'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    profileImage = json['profileImage'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roleId'] = this.roleId;
    data['subRoleId'] = this.subRoleId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['countryCode'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['referralCode'] = this.referralCode;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['profileImage'] = this.profileImage;
    data['rating'] = this.rating;
    return data;
  }
}
