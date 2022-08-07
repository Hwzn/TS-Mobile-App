import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class TeacherCoursesPageModel extends BaseNotifier {
  BuildContext context;
  TeacherCoursesPageModel() {
    getTeacherCourses();
  }

  List<Course> courses;
  void getTeacherCourses() async {
    setBusy();
    var res = await api.getTeacherCourses(context);
    res.fold((error) {
      UI.toast(error.message);
      setError();
    }, (data) {
      // Logger().w(data);
      courses = data.map<Course>((item) => Course.fromJson(item)).toList();
      setIdle();
    });
  }

  void deleteTeacherCourse(String id, ctx) async {
    var res = await api.deleteTeacherCourse(ctx, id: id);
    res.fold((error) {
      ErrorDialog().notification(error.message, Colors.red);
      setError();
    }, (data) {
      // Logger().w(data);
      getTeacherCourses();
      setIdle();
    });
  }
}
