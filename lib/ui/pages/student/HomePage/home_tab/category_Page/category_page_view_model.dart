import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/city_model.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/models/filter_model.dart';
import 'package:ts_academy/core/models/student_model.dart';
import 'package:ts_academy/core/models/subject.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class CategoryPageModel extends BaseNotifier {
  String subjectId;
  BuildContext context;
  FormGroup form;

  CategoryPageModel({this.subjectId, this.context}) {
    form = FormGroup(
      {
        'rate': FormControl(value: "HTL"),
        'subjectId': FormControl(value: subjectId),
        'gradeId': FormControl(value: null),
        'stageId': FormControl(value: null),
        'cityId': FormControl(value: null),
        'gender': FormControl(value: null),
        'page': FormControl<int>(value: 1),
        'limit': FormControl(value: "10"),
      },
    );
    filter(subjectId: form.control("subjectId").value, context: context);
    getCity(context);
    getStages(context);
    getSubject(context);
    getGrades(context);
  }
  FilterModel filterData;

  void filter({String subjectId, context}) async {
    form.control('subjectId').updateValue(subjectId);
    setBusy();
    var res = await api.getFilter(context: context, query: form.value);
    res.fold((error) {
      // UI.toast(error.message);
      setError();
    }, (data) {
      filterData = FilterModel.fromJson(data);
      setIdle();
    });
  }

  List<Stage> stages;
  List<Grade> grades;
  List<City> cities;

  void getCity(context) async {
    setBusy();
    var res = await api.getAllCities(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      cities = data.map<City>((item) => City.fromJson(item)).toList();
      setIdle();
    });
  }

  void getGrades(context) async {
    setBusy();
    var res = await api.getAllGrades(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      grades = data.map<Grade>((item) => Grade.fromJson(item)).toList();
      setIdle();
    });
  }

  void getStages(context) async {
    setBusy();
    var res = await api.getAllStages(context);
    res.fold((error) {
      // UI.toast(error.toString());
      setError();
    }, (data) {
      stages = data.map<Stage>((item) => Stage.fromJson(item)).toList();
      setIdle();
    });
  }

  RefreshController refreshController = RefreshController();

  onload(BuildContext context) async {
    FilterModel moreitems;

    form.control("page").updateValue(form.control("page").value + 1);

    var res;
    res = await api.getFilter(context: context, query: form.value);
    if (res != null) {
      res.fold((error) => UI.toast(error.toString()), (data) {
        var allCourses = data["allCourses"]
            .map<Course>((item) => Course.fromJson(item))
            .toList();
        filterData.allCourses.addAll(allCourses);
      });
    }

    refreshController.loadComplete();
  }

  List<Subject> subjects = [];

  void getSubject(context) async {
    setBusy();
    var res = await api.getAllSubjects(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      subjects = data.map<Subject>((item) => Subject.fromJson(item)).toList();
      setIdle();
    });
  }
}
