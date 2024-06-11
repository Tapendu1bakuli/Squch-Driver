class CountryModel {
  int? id;
  String? name;
  String? iso3;
  String? iso2;
  String? phonecode;
  String? currencyName;
  String? currencySymbol;
  String? flag;
  bool? isSelected;

  CountryModel(
      {this.id,
      this.name,
      this.iso3,
      this.iso2,
      this.phonecode,
      this.currencyName,
      this.currencySymbol,
      this.isSelected = false,
      this.flag});

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iso3 = json['iso3'];
    iso2 = json['iso2'];
    phonecode = json['phonecode'];
    currencyName = json['currencyName'];
    currencySymbol = json['currencySymbol'];
    flag = json['flag'];
    isSelected = json['isSelected'] == null ? false : json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['iso3'] = this.iso3;
    data['iso2'] = this.iso2;
    data['phonecode'] = this.phonecode;
    data['currencyName'] = this.currencyName;
    data['currencySymbol'] = this.currencySymbol;
    data['flag'] = this.flag;
    return data;
  }
}
