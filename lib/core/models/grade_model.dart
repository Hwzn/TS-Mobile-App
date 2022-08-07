import 'basic_data.dart';

class Grade {
  String sId;
  Name name;
  int gradeNumber;
  Stage stage;
  int iV;

  Grade({this.sId, this.name, this.gradeNumber, this.stage, this.iV});

  Grade.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    gradeNumber = json['gradeNumber'];
    stage = json['stage'] != null ? new Stage.fromJson(json['stage']) : null;
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['gradeNumber'] = this.gradeNumber;
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
  int iV;

  Stage({this.sId, this.name, this.stageNumber, this.iV});

  Stage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    stageNumber = json['stageNumber'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['stageNumber'] = this.stageNumber;
    data['__v'] = this.iV;
    return data;
  }
}
