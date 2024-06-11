/*
 * File name: model.dart
 * Last modified: 2022.02.27 at 23:37:17
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

abstract class Model {
  int? modelId;

  bool get hasData => modelId != null && modelId != 0;

  void fromJson(Map<String, dynamic> json) {
    modelId = intFromJson(
      json,
      'id',
    );
  }

  @override
  bool operator ==(dynamic other) {
    return other.modelId == this.modelId;
  }

  @override
  int get hashCode => this.modelId.hashCode;

  Map<String, dynamic> toJson();

  @override
  String toString() {
    return toJson().toString();
  }

/*  Color colorFromJson(Map<String, dynamic> json, String attribute,
      {String defaultHexColor = "#000000"}) {
    try {
      return json == null
          ? Ui.parseColor(defaultHexColor)
          : Ui.parseColor(json != null
              ? json[attribute] != null
                  ? json[attribute].toString()
                  : defaultHexColor
              : defaultHexColor);
    } catch (e) {
      throw Exception(
          'Error while parsing ' + attribute + '[' + e.toString() + ']');
    }
  }*/

  String stringFromJson(Map<String, dynamic> json, String attribute,
      {String defaultValue = ''}) {
    try {
      return json == null
          ? defaultValue
          : json != null
              ? json[attribute] != null
                  ? json[attribute].toString()
                  : defaultValue
              : defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing ' + attribute + '[' + e.toString() + ']');
    }
  }

/*  String countStringFromJson(Map<String, dynamic> json, String attribute,
      {String defaultValue = '0'}) {
    try {
      return json == null
          ? defaultValue
          : json != null
              ? json[attribute] != null
                  ? NumberFormat.compact(
                          locale: Get.find<TranslationService>()
                              .getLocale()
                              .countryCode)
                      .format(json[attribute])
                      .toString()
                  : defaultValue
              : defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing ' + attribute + '[' + e.toString() + ']');
    }
  }*/

/*  String transStringFromJson(Map<String, dynamic> json, String attribute,
      {String defaultValue = '', String? defaultLocale}) {
    try {
      if(json != null){
        if (json[attribute] != null) {
          if (json[attribute] is Map<String, dynamic>) {
            if(json[attribute][json[attribute].keys.toList().first] != null){
              defaultValue = json[attribute][json[attribute].keys.toList().first];
            }
            var json2 = json[attribute][defaultLocale ?? Get.locale?.languageCode];
            if (json2 == null) {
              var languageCode2 =
                  Get.find<TranslationService>().getLocale().languageCode;
              if (json[attribute][languageCode2] != null &&
                  json[attribute][languageCode2] != 'null')
                return json[attribute][languageCode2].toString();
              else
                return defaultValue;
            } else {
              if (json2 != null && json2 != 'null')
                return json2;
              else
                return defaultValue;
            }
          } else {
            return json[attribute].toString();
          }
        } else {
          return defaultValue;
        }
      }else{
        return defaultValue;
      }
    } catch (e) {
      throw Exception(
          'Error while parsing ' + attribute + '[' + e.toString() + ']');
    }
  }*/

  DateTime? dateFromJson(Map<String, dynamic> json, String attribute,
      {DateTime? defaultValue}) {
    try {
      return json == null
          ? defaultValue
          : json != null
              ? json[attribute] != null
                  ? DateTime.parse(json[attribute]).toLocal()
                  : defaultValue??DateTime(0)
              : defaultValue??DateTime(0);
    } catch (e) {
      throw Exception(
          'Error while parsing ' + attribute + '[' + e.toString() + ']');
    }
  }

  String durationFromJson(Map<String, dynamic> json, String attribute,
      {String defaultValue = '00:00',
      String fromFormat = "hh:mm a",
      String toFormat = "HH'h' mm'm'"}) {
    /*try {
      return DateFormat(toFormat).format(DateFormat(fromFormat)
          .parse(stringFromJson(json, attribute, defaultValue: defaultValue)));
    } catch (e) {
      return DateFormat(toFormat)
          .format(DateFormat(fromFormat).parse(defaultValue));
    }*/
    if (json != null) {
      if (json[attribute] != null) {
        return json[attribute];
      } else {
        return "00";
      }
    } else {
      return "00";
    }
  }

  dynamic mapFromJson(Map<String, dynamic> json, String attribute,
      {Map<dynamic, dynamic>? defaultValue}) {
    try {
      return json == null
          ? defaultValue
          : json != null
              ? json[attribute] != null
                  ? jsonDecode(json[attribute])
                  : defaultValue
              : defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing ' + attribute + '[' + e.toString() + ']');
    }
  }

  int intFromJson(Map<String, dynamic> json, String attribute,
      {int defaultValue = 0}) {
    try {
      if (json != null) {
        if (json[attribute] != null) {
          if (json[attribute] is int) {
            return json[attribute];
          }
          return int.parse(json[attribute]);
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

  bool boolFromJson(Map<String, dynamic> json, String attribute,
      {bool defaultValue = false}) {
    try {
      if (json != null) {
        if (json[attribute] != null) {
          if (json[attribute] is bool) {
            return json[attribute];
          } else if ((json[attribute] is String) &&
              !['0', '', 'false'].contains(json[attribute])) {
            return true;
          } else if ((json[attribute] is int) &&
              ![0, -1].contains(json[attribute])) {
            return true;
          }
          return false;
        }
        return defaultValue;
      } else
        return defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing ' + attribute + '[' + e.toString() + ']');
    }
  }

/*  Media mediaFromJson(Map<String, dynamic> json, String attribute) {
    try {
      Media media = new Media();
      if(json != null) {
        if (json['media'] != null && (json['media'] as List).length > 0) {
          if(json['media'][0] != null){
            media = Media.fromJson(json['media'][0]);
          }else{
            return media;
          }
        }
        return media;
      }else{
        return media;
      }
    } catch (e) {
      throw Exception(
          'Error while parsing ' + attribute + '[' + e.toString() + ']');
    }
  }*/

/*  List<Media> mediaListFromJson(Map<String, dynamic> json, String attribute) {
    try {
      List<Media> medias = [new Media()];
      if (json != null) {
        if (json['media'] != null && (json['media'] as List).length > 0) {
          medias = List.from(json['media'])
              .map((element) => Media.fromJson(element))
              .toSet()
              .toList();
        }
        return medias;
      } else
        return medias;
    } catch (e) {
      throw Exception(
          'Error while parsing ' + attribute + '[' + e.toString() + ']');
    }
  }*/

  List<T> listFromJsonArray<T>(Map<String, dynamic> json,
      List<String> attribute, T Function(Map<String, dynamic>) callback) {
    String _attribute = attribute
        .firstWhere((element) => (json[element] != null), orElse: () => "");
    return listFromJson(json, _attribute, callback);
  }

  List<T> listFromJson<T>(Map<String, dynamic> json, String attribute,
      T Function(Map<String, dynamic>) callback) {
    try {
      List<T> _list = <T>[];
      if (json != null) {
        if (json[attribute] != null &&
            json[attribute] is List &&
            json[attribute].length > 0) {
          json[attribute].forEach((v) {
            if (v is Map<String, dynamic>) {
              _list.add(callback(v));
            }
          });
        }
        return _list;
      } else
        return _list;
    } catch (e) {
      throw Exception('Error while parsing ' +
          attribute.toString() +
          '[' +
          e.toString() +
          ']');
    }
  }

  T? objectFromJson<T>(Map<String, dynamic> json, String attribute,
      T Function(Map<String, dynamic>) callback,
      {T? defaultValue = null}) {
    try {
      if (json != null) {
        if (json[attribute] != null &&
            json[attribute] is Map<String, dynamic>) {
          return callback(json[attribute]);
        }
        return defaultValue;
      } else
        return defaultValue;
    } catch (e) {
      throw Exception(
          'Error while parsing ' + attribute + '[' + e.toString() + ']');
    }
  }

  MediaType mediaTypeFromJson(Map<String, dynamic> json, String attribute) {
    MediaType mediaType = MediaType.text;
    try {
      if (json != null) {
        if (json['media'] != null && (json['media'] as List).length > 0) {
          if ((json['media'] as List).first['mime_type'].startsWith('image/')) {
            return MediaType.image;
          }
          if ((json['media'] as List).first['mime_type'].startsWith('video/')) {
            return MediaType.video;
          }
        }
        return mediaType;
      } else
        return mediaType;
    } catch (e) {
      throw Exception(
          'Error while parsing ' + attribute + '[' + e.toString() + ']');
    }
  }

/*  Future<VideoPlayerController> videoControllerFromJson(String url) async {
    try {
      final videoController = VideoPlayerController.network(url);
      await videoController.initialize();
      final videoDuration = videoController.value.duration;
      // final videoSize = videoController.value.size;
      //
      // print('Video Duration: ${videoDuration.inSeconds} seconds');
      // print('Video Size: ${videoSize.width}x${videoSize.height}');
      return videoController;
    } catch (e) {
      throw Exception('Error while parsing ' + url + '[' + e.toString() + ']');
    }
  }*/

  dynamic nullCheck(dynamic param) {
    return param == null ? null : param;
  }
}

enum MediaType { image, video, text }
