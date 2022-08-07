class Parent {
  List<String> students;
  String sId;
  int iV;

  Parent({this.students, this.sId, this.iV});

  Parent.fromJson(Map<String, dynamic> json) {
    students = json['students'].cast<String>();
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['students'] = this.students;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}