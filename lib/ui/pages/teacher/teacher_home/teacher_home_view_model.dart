import 'package:flutter/cupertino.dart';
import 'package:ts_academy/core/models/teacher_home_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class TeacherHomePageModel extends BaseNotifier {
  BuildContext context;
  TeacherHomePageModel() {
    getTeacherHomePage();
    // getAllInstructors();
  }
  // List<StuModel> students;
  // void getAllInstructors() async {
  //   setBusy();
  //   var res = await api.getAllStudents(context);
  //   res.fold((error) {
  //     UI.toast(error.message);
  //     setError();
  //   }, (data) {
  //     students =
  //         data.map<StuModel>((item) => StuModel.fromJson(item)).toList();
  //     setIdle();
  //   });
  // }

  TeacherHomeModel teacherHomeModel;
  void getTeacherHomePage() async {
    setBusy();
    var res = await api.getTeacherHomePage(context);
    res.fold((error) {
      UI.toast(error.message);
      setError();
    }, (data) {
      teacherHomeModel = TeacherHomeModel.fromJson(data);
      setIdle();
    });
  }
}
