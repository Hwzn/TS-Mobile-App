import 'basic_data.dart';
import 'city_model.dart';

class Student {
  String studentId;
  String sId;
  City city;
  Grade grade;
  Stage stage;
  int iV;

  Student(
      {this.studentId, this.sId, this.city, this.grade, this.stage, this.iV});

  Student.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    sId = json['_id'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    grade = json['grade'] != null ? new Grade.fromJson(json['grade']) : null;
    stage = json['stage'] != null ? new Stage.fromJson(json['stage']) : null;
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['_id'] = this.sId;
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    if (this.grade != null) {
      data['grade'] = this.grade.toJson();
    }
    if (this.stage != null) {
      data['stage'] = this.stage.toJson();
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

class Grade {
  String sId;
  Name name;
  Stage stage;
  int iV;

  Grade({this.sId, this.name, this.stage, this.iV});

  Grade.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    stage = json['stage'] != null
        ? (json['stage'] is String
            ? new Stage.fromString(json['stage'])
            : new Stage.fromJson(json['stage']))
        : null;
    iV = json['__v'];
  }

  Grade.fromString(String id) {
    sId = id;
    name = new Name(ar: id, en: id);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.stage != null) {
      data['stage'] = this.stage.toJson();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class Stage {
  String sId;
  Name name;
  int stageNumber;

  Stage({this.sId, this.name, this.stageNumber});

  Stage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    stageNumber = json['stageNumber'];
  }

  Stage.fromString(String id) {
    sId = id;
    name = new Name(ar: id, en: id);
    stageNumber = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['stageNumber'] = this.stageNumber;
    return data;
  }
}
