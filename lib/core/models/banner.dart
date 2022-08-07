import 'basic_data.dart';

class Banners {
  String sId;
  Name title;
  int priority;
  String image;
  int iV;

  Banners({this.sId, this.title, this.priority, this.image, this.iV});

  Banners.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'] != null ? new Name.fromJson(json['title']) : null;
    image = json['image'];
    priority = json['priority'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (title != null) {
      data['title'] = title.toJson();
    }
    if (image != null) {
      data['image'] = image;
    }
    data['priority'] = priority;
    data['image'] = image;
    data['__v'] = iV;
    return data;
  }
}
