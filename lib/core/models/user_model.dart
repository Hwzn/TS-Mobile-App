import 'package:ts_academy/core/models/Bank_Account_model.dart';
import 'package:ts_academy/core/models/city_model.dart';
import 'package:ts_academy/core/models/student_model.dart';

import 'course.dart';

class User {
  String userType;
  String tempCode;
  String defaultLang;
  List<String> fcmTokens;
  bool isActive;
  bool teacherApproved;
  String sId;
  String name;
  String avatar;
  String password;
  String email;
  String phone;
  String bio;
  String token;
  // Student student;
  String coverletter;
  String resume;
  dynamic cRating;
  String additionalPhone;
  // Parent parent;
  // Teacher teacher;
  List<Student> students;
  List<BankAccount> bankAccounts;
  List<Course> cart;
  List<Wallet> wallet;
  City city;
  Grade grade;
  Stage stage;
  String studentId;

  User({
    this.avatar,
    this.coverletter,
    this.resume,
    this.additionalPhone,
    this.userType,
    this.tempCode,
    this.defaultLang,
    this.fcmTokens,
    this.isActive,
    this.teacherApproved,
    this.sId,
    this.name,
    this.password,
    this.email,
    this.phone,
    this.cRating,
    this.studentId,
    // this.student,
    // this.parent,
    // this.teacher,
    this.bio,
    this.token,
    this.students,
    this.bankAccounts,
    this.cart,
    this.wallet,
    this.city,
    this.stage,
  });

  User.fromString(String id) {
    sId = id;
    name = id;
  }
  User.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    cRating = json['cRating'];
    coverletter = json['coverletter'];
    resume = json['resume'];
    additionalPhone = json['additionalPhone'];
    userType = json['userType'];
    tempCode = json['tempCode'];
    defaultLang = json['defaultLang'];
    if (json['fcmTokens'] != null) {
      fcmTokens = json['fcmTokens'].cast<String>();
    }
    isActive = json['isActive'];
    teacherApproved = json['teacherApproved'];
    sId = json['_id'];
    name = json['name'];
    password = json['password'];
    studentId = json['studentId'];
    email = json['email'];
    phone = json['phone'];
    // student =
    //     json['student'] != null ? new Student.fromJson(json['student']) : null;
    // parent =
    //     json['parent'] != null ? new Parent.fromJson(json['parent']) : null;
    // teacher = json['teacher'] != null
    //     ? json['teacher'] is String
    //         ? new Teacher.fromString(json['teacher'])
    //         : new Teacher.fromJson(json['teacher'])
    // : null;
    bio = json['bio'];
    token = json['token'];

    if (json['students'] != null) {
      students = [];
      json['students'].forEach((v) {
        students.add(new Student.fromJson(v));
      });
    }

    if (json['bankAccounts'] != null) {
      bankAccounts = [];
      json['bankAccounts'].forEach((v) {
        bankAccounts.add(
            v is String ? BankAccount.fromString(v) : BankAccount.fromJson(v));
      });
    }
    // if (json['cart'] != null) {
    //   cart = [];
    //   json['cart'].forEach((v) {
    //     cart.add(Course.fromJson(v));
    //   });
    // }
    if (json['wallet'] != null) {
      wallet = [];
      json['wallet'].forEach((v) {
        wallet.add(v is String ? Wallet.fromString(v) : Wallet.fromJson(v));
      });
    }
    city = json['city'] != null
        ? json['city'] is String
            ? new City.fromString(json['city'])
            : new City.fromJson(json['city'])
        : null;
    grade = json['grade'] != null
        ? json['grade'] is String
            ? new Grade.fromString(json['grade'])
            : new Grade.fromJson(json['grade'])
        : null;
    stage = json['stage'] != null
        ? json['stage'] is String
            ? new Stage.fromString(json['stage'])
            : new Stage.fromJson(json['stage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userType'] = this.userType;
    data['tempCode'] = this.tempCode;
    data['defaultLang'] = this.defaultLang;
    if (this.fcmTokens != null) {
      data['fcmTokens'] = this.fcmTokens;
    }
    data['isActive'] = this.isActive;
    data['teacherApproved'] = this.teacherApproved;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['password'] = this.password;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['studentId'] = this.studentId;
    data['avatar'] = this.avatar;
    data['coverletter'] = this.coverletter;
    data['resume'] = this.resume;
    data['additionalPhone'] = this.additionalPhone;
    data['cRating'] = this.cRating;

    data['token'] = this.token;
    data['bio'] = this.bio;
    return data;
  }
}

enum WalletStatus { pending, approved }

class Wallet {
  String sId;
  int date;
  String type;
  String status;
  int value;

  Wallet({this.sId, this.date, this.type, this.status, this.value});

  Wallet.fromString(String id) {
    sId = id;
  }

  Wallet.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    date = json['date'];
    type = json['type'];
    status = json['status'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['date'] = this.date;
    data['type'] = this.type;
    data['status'] = this.status;
    data['value'] = this.value;
    return data;
  }
}
