class DriverDetailsItem {
  String? title;
  String? image;
  String? status;

  DriverDetailsItem({this.title, this.image, this.status});

  DriverDetailsItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}
