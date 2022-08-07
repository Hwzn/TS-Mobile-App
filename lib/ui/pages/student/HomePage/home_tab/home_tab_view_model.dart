import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:ts_academy/core/models/student_home_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/pricing.service.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class HomeTabPageModel extends BaseNotifier {
  BuildContext context;

  HomeTabPageModel({this.context}) {
    // getBanners();

    getStudentHomePage();

    // getAllInstructors();
  }

  // void getBanners() async {
  //   setBusy();
  //   var res = await api.getBanners(context);
  //   res.fold((error) {
  //     UI.toast(error.message);
  //     setError();
  //   }, (data) {
  //     // Logger().w(data);
  //     banners = data
  //         .map<StudentBanners>((item) => StudentBanners.fromJson(item))
  //         .toList();
  //     setIdle();
  //   });
  // }

  // List<Instructor> instructors;
  // void getAllInstructors() async {
  //   setBusy();
  //   var res = await api.getAllTeachers(context);
  //   res.fold((error) {
  //     UI.toast(error.message);
  //     setError();
  //   }, (data) {
  //     instructors =
  //         data.map<Teacher>((item) => Teacher.fromJson(item)).toList();
  //     setIdle();
  //   });
  // }

  StudentHome homeModel;
  void getStudentHomePage() async {
    setBusy();
    await locator<PricingService>().getPricing();
    var res = await api.getStudentHome(context);
    res.fold((error) {
      UI.toast(error.message);
      setError();
    }, (data) {
      // Logger().w(data);
      homeModel = StudentHome.fromJson(data);
      setIdle();
    });
  }
}
