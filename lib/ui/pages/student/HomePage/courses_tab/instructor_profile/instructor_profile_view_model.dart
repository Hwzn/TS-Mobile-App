import 'package:flutter/cupertino.dart';
import 'package:ts_academy/core/models/teacher_profile_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';

class InstructorProfilePageModel extends BaseNotifier {
  String teacherId;
  BuildContext context;
  InstructorProfilePageModel({this.teacherId}) {
    getTeacherProfile(context);
  }
  TecherProfileModel teacher;
  void getTeacherProfile(context) async {
    setBusy();
    var res = await api.getTeacherById(context, teacherId: teacherId);
    res.fold((error) {
      // print(error.message);
      setError();
    }, (data) {
      teacher = TecherProfileModel.fromJson(data);
      setIdle();
    });
  }
}
