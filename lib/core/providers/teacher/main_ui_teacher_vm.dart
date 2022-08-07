import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ts_academy/core/models/grade_model.dart';
import 'package:ts_academy/ui/routes/ui.dart';

import '../base_notifier.dart';

class MainUITeacherVM extends BaseNotifier {
  BuildContext context;
  MainUITeacherVM() {
    getGrades(context);
    getStages(context);
  }
  int _currentPage = 0;
  int get currentPage => _currentPage;
  PageController _controller = PageController();
  PageController get controller => _controller;

  onSwipe(int page) {
    // Logger().w(page);
    _currentPage = page;
    setState();
  }

  changePage(int page) {
    // Logger().w(page);
    _currentPage = page;
    setState();
    _controller
        .animateToPage(page,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate)
        .then((value) {});
  }

  List<Grade> grades = [];
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

  List<Stage> stages = [];
  void getStages(context) async {
    setBusy();
    var res = await api.getAllStages(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      stages = data.map<Stage>((item) => Stage.fromJson(item)).toList();
      setIdle();
    });
  }
}
