import 'address_model.dart';

class InitRideResponse {
  bool? status;
  String? message;
  InitRideData? data;

  InitRideResponse({this.status, this.message, this.data});

  InitRideResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new InitRideData.fromJson(json['data']) : null;
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

class InitRideData {
  String? status;
  DistanceMatrix? distanceMatrix;
  List<Charges>? charges;
  Address? origin;
  Address? destination;

  InitRideData({this.status, this.distanceMatrix, this.charges});

  InitRideData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    distanceMatrix = json['distanceMatrix'] != null
        ? new DistanceMatrix.fromJson(json['distanceMatrix'])
        : null;
    if (json['charges'] != null) {
      charges = <Charges>[];
      json['charges'].forEach((v) {
        charges!.add(new Charges.fromJson(v));
      });
    }
    origin =
    json['origin'] != null ? new Address.fromJson(json['origin']) : null;
    destination = json['destination'] != null
        ? new Address.fromJson(json['destination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.distanceMatrix != null) {
      data['distanceMatrix'] = this.distanceMatrix!.toJson();
    }
    if (this.charges != null) {
      data['charges'] = this.charges!.map((v) => v.toJson()).toList();
    }
    if (this.origin != null) {
      data['origin'] = this.origin!.toJson();
    }
    if (this.destination != null) {
      data['destination'] = this.destination!.toJson();
    }
    return data;
  }
}

class DistanceMatrix {
  String? origin;
  String? destination;
  Param? param;

  DistanceMatrix({this.origin, this.destination, this.param});

  DistanceMatrix.fromJson(Map<String, dynamic> json) {
    origin = json['origin'];
    destination = json['destination'];
    param = json['param'] != null ? new Param.fromJson(json['param']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['origin'] = this.origin;
    data['destination'] = this.destination;
    if (this.param != null) {
      data['param'] = this.param!.toJson();
    }
    return data;
  }
}

class Param {
  Distance? distance;
  Distance? duration;
  String? status;

  Param({this.distance, this.duration, this.status});

  Param.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ? new Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? new Distance.fromJson(json['duration'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.distance != null) {
      data['distance'] = this.distance!.toJson();
    }
    if (this.duration != null) {
      data['duration'] = this.duration!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Distance {
  String? text;
  num? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}

class Charges {
  num? id;
  num? vehicleTypeId;
  num? minCharge;
  num? perKmCharge;
  VehicleType? vehicleType;
  num? price;
  num? distance;

  Charges(
      {this.id,
        this.vehicleTypeId,
        this.minCharge,
        this.perKmCharge,
        this.vehicleType,
        this.price,
        this.distance});

  Charges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleTypeId = json['vehicleTypeId'];
    minCharge = json['minCharge'];
    perKmCharge = json['perKmCharge'];
    vehicleType = json['vehicleType'] != null
        ? new VehicleType.fromJson(json['vehicleType'])
        : null;
    price = json['price']??0.00;
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicleTypeId'] = this.vehicleTypeId;
    data['minCharge'] = this.minCharge;
    data['perKmCharge'] = this.perKmCharge;
    if (this.vehicleType != null) {
      data['vehicleType'] = this.vehicleType!.toJson();
    }
    data['price'] = this.price??0.00;
    data['distance'] = this.distance;
    return data;
  }
}

class VehicleType {
  num? id;
  String? name;
  String? image;

  VehicleType({this.id, this.name, this.image});

  VehicleType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
