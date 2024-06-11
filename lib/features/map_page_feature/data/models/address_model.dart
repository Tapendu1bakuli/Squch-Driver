import 'package:squch_driver/core/model/model.dart';
import 'package:squch_driver/core/utils/date_time_utilities.dart';

enum TripTimelineStatus {
  done,
  inProgress,
  next,
}

class Address extends Model {
  String? id;
  int? tripId;
  String? placeId;
  String? description;
  String? location;
  String? address;
  double? latitude;
  double? longitude;
  bool? isDefault;
  String? image;
  String? reachedAt;
  String? reachedAtHour;
  String? expectedTime;
  String? expectedTimeHour;
  TripTimelineStatus? progressStatus;

  Address({
    this.id,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.image,
    this.reachedAt,
    this.progressStatus,
    this.isDefault = false,
    this.location,
    this.expectedTime,
    this.reachedAtHour,
    this.expectedTimeHour,
    this.placeId,
    this.tripId,
  });

  Address.fromJson(Map<String, dynamic> json) {
    // description = stringFromJson(json, 'description').replaceAll('\n', ' ');
    // address = stringFromJson(json, 'address').replaceAll('\n', ' ');
    // latitude = doubleFromJson(json, 'latitude', defaultValue: null);
    // longitude = doubleFromJson(json, 'longitude', defaultValue: null);
    // isDefault = boolFromJson(json, 'default');
    id =  stringFromJson(json, 'id');
    description = json['description'];
    address = json['address'];
    latitude = doubleFromJson(json, 'latitude');
    longitude = doubleFromJson(json, 'longitude');
    isDefault = json['default'];
    reachedAt = json['reachedAt'];
    progressStatus = getProgressStatus(json['status']);
    location = stringFromJson(json, 'location');
    expectedTime = stringFromJson(json, 'expectedTime');
    reachedAtHour = json['reachedAt'] == null
        ? null
        : DateTimeUtility()
        .parse(dateTime: json['reachedAt'], returnFormat: "hh:mm a");
    expectedTimeHour = json['expectedTime'] == null
        ? ""
        : DateTimeUtility()
        .parse(dateTime: json['expectedTime'], returnFormat: "hh:mm a");
    placeId = stringFromJson(json, 'placeId');
    tripId = intFromJson(json, 'tripId');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] =
    this.description == null ? getDescription : this.description;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['default'] = this.isDefault;
    data['status'] = this.progressStatus.toString();

    data['reachedAt'] = this.reachedAt;
    data['location'] = this.location;
    data['expectedTime'] = this.expectedTime;
    data['reachedAtHour'] = this.reachedAtHour;
    data['expectedTimeHour'] = this.expectedTimeHour;
    data['placeId'] = this.placeId;
    data['tripId'] = this.tripId;
    return data;
  }

  bool isUnknown() {
    return longitude == null;
  }

  String get getDescription {
    if (hasDescription()) return location ?? description ?? "";
    return location ?? address ?? "";
  }

  String get getAddress {
    if (hasAddress()) return address ?? "";
    return address ?? "";
  }

  bool hasDescription() {
    if (description?.isNotEmpty ?? false) return true;
    return false;
  }

  bool hasAddress() {
    if (address?.isNotEmpty ?? false) return true;
    return false;
  }

  TripTimelineStatus? getProgressStatus([json]) {
    switch (json) {
      case "reached":
        return TripTimelineStatus.done;
      case "ontheway":
        return TripTimelineStatus.inProgress;
      case "pending":
      default:
        return TripTimelineStatus.next;
    }
  }
}


double? doubleFromJson(Map<String, dynamic> json, String attribute,
    {int decimal = 2, double? defaultValue = 0.0}) {
  try {
    if (json != null) {
      if (json[attribute] != null) {
        if (json[attribute] is double) {
          return double.parse(json[attribute].toStringAsFixed(decimal));
        }
        if (json[attribute] is int) {
          return double.parse(
              json[attribute].toDouble().toStringAsFixed(decimal));
        }
        return double.parse(
            double.tryParse(json[attribute])!.toStringAsFixed(decimal));
      }
      return defaultValue;
    } else {
      return defaultValue;
    }
  } catch (e) {
    throw Exception(
        'Error while parsing ' + attribute + '[' + e.toString() + ']');
  }
}
