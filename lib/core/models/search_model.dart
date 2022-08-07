import 'package:ts_academy/core/models/course.dart';

import 'filter_model.dart';

class SearchModel {
  List<Course> courses;
  List<Instructor> teachers;

  SearchModel({this.courses, this.teachers});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['courses'] != null) {
      courses = new List<Course>();
      json['courses'].forEach((v) {
        courses.add(new Course.fromJson(v));
      });
    }
    if (json['teachers'] != null) {
      teachers = new List<Instructor>();
      json['teachers'].forEach((v) {
        teachers.add(new Instructor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.courses != null) {
      data['courses'] = this.courses.map((v) => v.toJson()).toList();
    }
    if (this.teachers != null) {
      data['teachers'] = this.teachers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TecherSearch {
  String name;
  String avatar;
  int noOfStudents;
  int noOfCourses;
  int rate;
  String bio;
  String userId;

  TecherSearch(
      {this.name,
      this.avatar,
      this.noOfStudents,
      this.noOfCourses,
      this.rate,
      this.bio,
      this.userId});

  TecherSearch.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
    noOfStudents = json['noOfStudents'];
    noOfCourses = json['noOfCourses'];
    rate = json['rate'];
    bio = json['bio'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['noOfStudents'] = this.noOfStudents;
    data['noOfCourses'] = this.noOfCourses;
    data['rate'] = this.rate;
    data['bio'] = this.bio;
    data['userId'] = this.userId;
    return data;
  }
}
