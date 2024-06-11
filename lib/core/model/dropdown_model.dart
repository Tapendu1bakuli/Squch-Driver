class DropdownModel {
  int uniqueid;
  String id;
  String label;
  String? dependentId;
  DropdownModel({required this.uniqueid,required this.id, required this.label,this.dependentId});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['dependent_id'] = this.dependentId??"";
    return data;
  }
}