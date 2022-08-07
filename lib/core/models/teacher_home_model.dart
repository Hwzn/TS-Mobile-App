import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/models/review.dart';

class TeacherHomeModel {
  int noOfCourses;
  num rate;
  int noOfStudents;
  List<Review> latestFeedback;
  List<Course> todayCourses;

  TeacherHomeModel(
      {this.noOfCourses,
      this.rate,
      this.noOfStudents,
      this.latestFeedback,
      this.todayCourses});

  TeacherHomeModel.fromJson(Map<String, dynamic> json) {
    noOfCourses = json['noOfCourses'];
    rate = json['rate'];
    noOfStudents = json['noOfStudents'];
    if (json['latestFeedback'] != null) {
      latestFeedback = <Review>[];
      json['latestFeedback'].forEach((v) {
        latestFeedback.add(Review.fromJson(v));
      });
    }
    if (json['todayCourses'] != null) {
      todayCourses = <Course>[];
      json['todayCourses'].forEach((v) {
        todayCourses.add(Course.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noOfCourses'] = this.noOfCourses;
    data['rate'] = this.rate;
    data['noOfStudents'] = this.noOfStudents;
    if (this.latestFeedback != null) {
      data['latestFeedback'] =
          this.latestFeedback.map((v) => v.toJson()).toList();
    }
    if (this.todayCourses != null) {
      data['todayCourses'] = this.todayCourses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
