import 'package:squch_driver/core/model/country_model.dart';

class RegistrationMasterDataModel {
  bool? status;
  String? message;
  RegistrationMasterData? data;

  RegistrationMasterDataModel({this.status, this.message, this.data});

  RegistrationMasterDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new RegistrationMasterData.fromJson(json['data']) : null;
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

class RegistrationMasterData {
  String? status;
  List<CountryModel>? countries;
  List<Currencies>? currencies;
  List<Languages>? languages;

  RegistrationMasterData({this.status, this.countries, this.currencies, this.languages});

  RegistrationMasterData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['countries'] != null) {
      countries = <CountryModel>[];
      json['countries'].forEach((v) {
        countries!.add(CountryModel.fromJson(v));
      });
    }
    if (json['currencies'] != null) {
      currencies = <Currencies>[];
      json['currencies'].forEach((v) {
        currencies!.add(new Currencies.fromJson(v));
      });
    }
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(new Languages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.countries != null) {
      data['countries'] = this.countries!.map((v) => v.toJson()).toList();
    }
    if (this.currencies != null) {
      data['currencies'] = this.currencies!.map((v) => v.toJson()).toList();
    }
    if (this.languages != null) {
      data['languages'] = this.languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Currencies {
  int? id;
  String? code;
  String? name;
  String? symbol;

  Currencies({this.id, this.code, this.name, this.symbol});

  Currencies.fromJson(Map<String, dynamic> json) {
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

class Languages {
  int? id;
  String? code;
  String? name;

  Languages({this.id, this.code, this.name});

  Languages.fromJson(Map<String, dynamic> json) {
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
