class IntroScreenResponseModel {
  bool? status;
  String? message;
  IntroScreenData? data;

  IntroScreenResponseModel({this.status, this.message, this.data});

  IntroScreenResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new IntroScreenData.fromJson(json['data']) : null;
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

class IntroScreenData {
  String? status;
  Content? content;

  IntroScreenData({this.status, this.content});

  IntroScreenData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    return data;
  }
}

class Content {
  int? id;
  String? slug;
  String? pageTitle;
  String? pageContent;
  String? coverImage;
  List<Sliders>? sliders;

  Content(
      {this.id,
        this.slug,
        this.pageTitle,
        this.pageContent,
        this.coverImage,
        this.sliders});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    pageTitle = json['pageTitle'];
    pageContent = json['pageContent'];
    coverImage = json['coverImage'];
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(new Sliders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['pageTitle'] = this.pageTitle;
    data['pageContent'] = this.pageContent;
    data['coverImage'] = this.coverImage;
    if (this.sliders != null) {
      data['sliders'] = this.sliders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sliders {
  int? id;
  int? contentId;
  String? image;

  Sliders({this.id, this.contentId, this.image});

  Sliders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contentId = json['contentId'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['contentId'] = this.contentId;
    data['image'] = this.image;
    return data;
  }
}
