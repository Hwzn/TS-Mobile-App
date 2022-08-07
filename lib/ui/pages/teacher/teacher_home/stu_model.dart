import '../../../../core/models/city_model.dart';
import '../../../../core/models/student_model.dart';

class StuModel {
  String sId;
  String studentId;
  dynamic city;
  String grade;
  String stage;
  int iV;
  User user;

  StuModel(
      {this.sId,
      this.studentId,
      this.city,
      this.grade,
      this.stage,
      this.iV,
      this.user});

  StuModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentId = json['studentId'];
    if (json['city'] is String) {
      city = json['city'];
    } else {
      city = json['city'] != null ? new City.fromJson(json['city']) : null;
    }
    grade = json['grade'];
    stage = json['stage'];
    iV = json['__v'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['studentId'] = this.studentId;
    data['city'] = this.city;
    data['grade'] = this.grade;
    data['stage'] = this.stage;
    data['__v'] = this.iV;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String sId;
  String userType;
  String tempCode;
  String defaultLang;
  // List<Null> fcmTokens;
  bool isActive;
  String name;
  String password;
  String email;
  String phone;
  dynamic student;

  User({
    this.sId,
    this.userType,
    this.tempCode,
    this.defaultLang,
    // this.fcmTokens,
    this.isActive,
    this.name,
    this.password,
    this.email,
    this.phone,
    this.student,
  });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userType = json['userType'];
    tempCode = json['tempCode'];
    defaultLang = json['defaultLang'];
    // if (json['fcmTokens'] != null) {
    //   fcmTokens = new List<Null>();
    //   json['fcmTokens'].forEach((v) {
    //     fcmTokens.add(new Null.fromJson(v));
    //   });
    // }
    isActive = json['isActive'];
    name = json['name'];
    password = json['password'];
    email = json['email'];
    phone = json['phone'];
    if (json['student'] is String) {
      student = json['student'];
    } else {
      // student = new List<Student>();
      // json['student'].forEach((v) {
      //   student.add(new Student.fromJson(v));
      // });
       student = json['student'] != null ? new Student.fromJson(json['student']) : null;
      
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userType'] = this.userType;
    data['tempCode'] = this.tempCode;
    data['defaultLang'] = this.defaultLang;
    // if (this.fcmTokens != null) {
    //   data['fcmTokens'] = this.fcmTokens.map((v) => v.toJson()).toList();
    // }
    data['isActive'] = this.isActive;
    data['name'] = this.name;
    data['password'] = this.password;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['student'] = this.student;
    return data;
  }
}
