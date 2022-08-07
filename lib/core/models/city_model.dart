import 'basic_data.dart';

class City {
  String sId;
  Name name;
  Loc loc;
  int iV;

  City({this.sId, this.name, this.loc, this.iV});

  City.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    loc = json['loc'] != null ? new Loc.fromJson(json['loc']) : null;
    iV = json['__v'];
  }

  City.fromString(String id) {
    sId = id;
    name = new Name(ar: id, en: id);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.loc != null) {
      data['loc'] = this.loc.toJson();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class Loc {
  String type;
  List<double> coordinates;

  Loc({this.type, this.coordinates});

  Loc.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
