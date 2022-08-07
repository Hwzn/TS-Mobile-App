// import 'teacher_model.dart';

// class Instructor {
//   String sId;
//   String city;
//   String additionalPhone;
//   String coverletter;
//   String resume;
//   int iV;
//   User user;

//   Instructor(
//       {this.sId,
//       this.city,
//       this.additionalPhone,
//       this.coverletter,
//       this.resume,
//       this.iV,
//       this.user});

//   Instructor.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     city = json['city'];
//     additionalPhone = json['additionalPhone'];
//     coverletter = json['coverletter'];
//     resume = json['resume'];
//     iV = json['__v'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['city'] = this.city;
//     data['additionalPhone'] = this.additionalPhone;
//     data['coverletter'] = this.coverletter;
//     data['resume'] = this.resume;
//     data['__v'] = this.iV;
//     if (this.user != null) {
//       data['user'] = this.user.toJson();
//     }
//     return data;
//   }
// }

// class User {
//   String sId;
//   String userType;
//   String tempCode;
//   String defaultLang;
//   List<String> fcmTokens;
//   bool isActive;
//   String name;
//   String password;
//   String email;
//   String phone;
//   dynamic teacher;
//   int iV;

//   User(
//       {this.sId,
//       this.userType,
//       this.tempCode,
//       this.defaultLang,
//       this.fcmTokens,
//       this.isActive,
//       this.name,
//       this.password,
//       this.email,
//       this.phone,
//       this.teacher,
//       this.iV});

//   User.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     userType = json['userType'];
//     tempCode = json['tempCode'];
//     defaultLang = json['defaultLang'];
//     // if (json['fcmTokens'] != null) {
//     //   fcmTokens = new List<String>();
//     //   json['fcmTokens'].forEach((v) {
//     //     fcmTokens.add(new String.fromJson(v));
//     //   });
//     // }
//     isActive = json['isActive'];
//     name = json['name'];
//     password = json['password'];
//     email = json['email'];
//     phone = json['phone'];
//     if (json['teacher'] is String) {
//       teacher = json['teacher'];
//     } else {
//       teacher = json['teacher'] != null
//           ? new Teacher.fromJson(json['teacher'])
//           : null;
//     }
//     iV = json['__v'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['userType'] = this.userType;
//     data['tempCode'] = this.tempCode;
//     data['defaultLang'] = this.defaultLang;
//     // if (this.fcmTokens != null) {
//     //   data['fcmTokens'] = this.fcmTokens.map((v) => v.toJson()).toList();
//     // }
//     data['isActive'] = this.isActive;
//     data['name'] = this.name;
//     data['password'] = this.password;
//     data['email'] = this.email;
//     data['phone'] = this.phone;
//     data['teacher'] = this.teacher;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
