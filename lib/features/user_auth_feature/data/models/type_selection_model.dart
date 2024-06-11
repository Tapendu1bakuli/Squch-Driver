class TypeSelectionModel {
  String? typeSelectionTitle;
  String? typeSelectionSubTitle;
  String? typeSelectionTopContainerText;
  String? typeSelectionContainerIcons;
  String value="";
  bool? isSelected;

  TypeSelectionModel({this.typeSelectionTitle,this.typeSelectionSubTitle,this.typeSelectionTopContainerText,this.typeSelectionContainerIcons,this.isSelected = false,required this.value});

  TypeSelectionModel.fromJson(Map<String, dynamic> json) {
    typeSelectionTitle = json['typeSelectionTitle'];
    typeSelectionSubTitle = json['typeSelectionSubTitle'];
    typeSelectionTopContainerText = json['typeSelectionTopContainerText'];
    typeSelectionContainerIcons = json['typeSelectionContainerIcons'];
    isSelected = json['isSelected'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeSelectionTitle'] = this.typeSelectionTitle;
    data['typeSelectionSubTitle'] = this.typeSelectionSubTitle;
    data['typeSelectionTopContainerText'] = this.typeSelectionTopContainerText;
    data['typeSelectionContainerIcons'] = this.typeSelectionContainerIcons;
    data['value'] = this.value;
    data['isSelected'] = this.isSelected;
    return data;
  }
}