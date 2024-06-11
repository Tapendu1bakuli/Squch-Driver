class NewMessageArrivedModel {
  Message? message;

  NewMessageArrivedModel({this.message});

  NewMessageArrivedModel.fromJson(Map<String, dynamic> json) {
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  int? id;
  int? inboxId;
  int? userId;
  String? senderType;
  String? message;
  String? createdAt;
  String? updatedAt;
  User? user;
  Inbox? inbox;

  Message(
      {this.id,
        this.inboxId,
        this.userId,
        this.senderType,
        this.message,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.inbox});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inboxId = json['inboxId'];
    userId = json['userId'];
    senderType = json['senderType'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    inbox = json['inbox'] != null ? new Inbox.fromJson(json['inbox']) : null;
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
    if (this.inbox != null) {
      data['inbox'] = this.inbox!.toJson();
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
  Role? role;
  String? address;
  String? latitude;
  String? longitude;
  String? isOnline;
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
        this.role,
        this.address,
        this.latitude,
        this.longitude,
        this.isOnline,
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
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isOnline = json['isOnline'];
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
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isOnline'] = this.isOnline;
    data['rating'] = this.rating;
    return data;
  }
}

class Role {
  int? id;
  String? name;
  String? slug;
  Null? permissionDetails;

  Role({this.id, this.name, this.slug, this.permissionDetails});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    permissionDetails = json['permissionDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['permissionDetails'] = this.permissionDetails;
    return data;
  }
}

class Inbox {
  int? id;
  int? tripId;
  int? driverId;
  int? customerId;
  String? lastMessage;
  String? userSeen;
  int? userUnseenNumbers;
  String? driverSeen;
  int? driverUnseenNumbers;

  Inbox(
      {this.id,
        this.tripId,
        this.driverId,
        this.customerId,
        this.lastMessage,
        this.userSeen,
        this.userUnseenNumbers,
        this.driverSeen,
        this.driverUnseenNumbers});

  Inbox.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripId = json['tripId'];
    driverId = json['driverId'];
    customerId = json['customerId'];
    lastMessage = json['lastMessage'];
    userSeen = json['userSeen'];
    userUnseenNumbers = json['userUnseenNumbers'];
    driverSeen = json['driverSeen'];
    driverUnseenNumbers = json['driverUnseenNumbers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tripId'] = this.tripId;
    data['driverId'] = this.driverId;
    data['customerId'] = this.customerId;
    data['lastMessage'] = this.lastMessage;
    data['userSeen'] = this.userSeen;
    data['userUnseenNumbers'] = this.userUnseenNumbers;
    data['driverSeen'] = this.driverSeen;
    data['driverUnseenNumbers'] = this.driverUnseenNumbers;
    return data;
  }
}
