import 'course.dart';

class TecherProfileModel {
  String bio;
  List<Course> courses;
  int noOfCourses;
  String name;
  String userId;
  String avatar;
  num rate;
  int noOfStudents;

  TecherProfileModel(
      {this.bio,
      this.courses,
      this.noOfCourses,
      this.name,
      this.userId,
      this.avatar,
      this.rate,
      this.noOfStudents});

  TecherProfileModel.fromJson(Map<String, dynamic> json) {
    bio = json['bio'];
    if (json['courses'] != null) {
      courses = new List<Course>();
      json['courses'].forEach((v) {
        courses.add(new Course.fromJson(v));
      });
    }
    noOfCourses = json['noOfCourses'];
    name = json['name'];
    userId = json['userId'];
    avatar = json['avatar'];
    rate = json['rate'];
    noOfStudents = json['noOfStudents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bio'] = this.bio;
    if (this.courses != null) {
      data['courses'] = this.courses.map((v) => v.toJson()).toList();
    }
    data['noOfCourses'] = this.noOfCourses;
    data['name'] = this.name;
    data['userId'] = this.userId;
    data['avatar'] = this.avatar;
    data['rate'] = this.rate;
    data['noOfStudents'] = this.noOfStudents;
    return data;
  }
}
