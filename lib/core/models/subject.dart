import 'basic_data.dart';

class Subject {
  String sId;
  Name name;
  String image;

  Subject({this.sId, this.name, this.image});

  Subject.fromString(String id) {
    sId = id;
    name = new Name(ar: id, en: id);
    image = id;
  }
  Subject.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['image'] = this.image;
    return data;
  }
}
