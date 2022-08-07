import 'package:ts_academy/core/models/course.dart';

class FilterModel {
  List<Instructor> topInstructors;
  List<Course> featuresCourses;
  List<Course> allCourses;

  FilterModel({this.topInstructors, this.featuresCourses, this.allCourses});

  FilterModel.fromJson(Map<String, dynamic> json) {
    if (json['topInstructors'] != null) {
      topInstructors = <Instructor>[];
      json['topInstructors'].forEach((v) {
        topInstructors.add(Instructor.fromJson(v));
      });
    }
    if (json['featuresCourses'] != null) {
      featuresCourses = <Course>[];
      json['featuresCourses'].forEach((v) {
        featuresCourses.add(Course.fromJson(v));
      });
    }
    if (json['allCourses'] != null) {
      allCourses = <Course>[];
      json['allCourses'].forEach((v) {
        allCourses.add(Course.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.topInstructors != null) {
      data['topInstructors'] =
          this.topInstructors.map((v) => v.toJson()).toList();
    }
    if (this.featuresCourses != null) {
      data['featuresCourses'] =
          this.featuresCourses.map((v) => v.toJson()).toList();
    }
    if (this.allCourses != null) {
      data['allCourses'] = this.allCourses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Instructor {
  String name;
  String avatar;
  int noOfStudents;
  int noOfCourses;
  int noOfReviews;
  num rate;
  String bio;
  String userId;

  Instructor(
      {this.name,
      this.avatar,
      this.noOfStudents,
      this.noOfCourses,
      this.rate,
      this.bio,
      this.userId});

  Instructor.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
    noOfStudents = json['noOfStudents'];
    noOfReviews = json['noOfReviews'];
    noOfCourses = json['noOfCourses'];
    rate = json['rate'] ?? 5.0;
    bio = json['bio'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['noOfStudents'] = this.noOfStudents;
    data['noOfCourses'] = this.noOfCourses;
    data['noOfReviews'] = this.noOfReviews;
    data['rate'] = this.rate;
    data['bio'] = this.bio;
    data['userId'] = this.userId;
    return data;
  }
}
