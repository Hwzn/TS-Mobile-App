import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/review_model.dart';
import 'package:ts_academy/core/models/subject.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import '../../../../../../core/services/localization/localization.dart';

class StatisticsPageModel extends BaseNotifier {
  final BuildContext context;
  final AppLocalizations locale;
  FormGroup form;
  String lastMonthKey;
  String currentMonthKey;
  ReviewModel lastMonth;
  ReviewModel currentMonth;
  AuthenticationService auth;
  List<Subject> subjects = [];

  StatisticsPageModel(this.context, this.locale) {
    form = FormGroup({
      "subject": FormControl(),
    });
    auth = locator<AuthenticationService>();

    lastMonthKey = DateFormat("MM-yyy")
        .format(DateTime.now().subtract(Duration(days: 30)));
    currentMonthKey = DateFormat("MM-yyy").format(DateTime.now());
    // getStudentReview();
    getSubject();
    chartData = [
      ChartData(locale.get('Attendees'), 0, 0),
      ChartData(locale.get('performance'), 0, 0),
      ChartData(locale.get('Grades'), 0, 0),
      ChartData(locale.get('Understanding'), 0, 0),
    ];
  }

  void getSubject() async {
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

  void getStudentReview(String subjectId) async {
    setBusy();
    final res = await api.getStudentReview(
      context,
      studentId: "${auth.user.sId}",
      subjectId: "$subjectId",
    );
    res.fold(
      (e) => UI.showSnackBarMessage(context: context, message: e.toString()),
      (data) {
        lastMonth = ReviewModel.fromJson(data[lastMonthKey]);
        currentMonth = ReviewModel.fromJson(data[currentMonthKey]);
        chartData.clear();
        chartData.add(ChartData(
          locale.get('Attendees'),
          lastMonth.attendance.toDouble(),
          currentMonth.attendance.toDouble(),
        ));
        chartData.add(ChartData(
          locale.get('performance'),
          lastMonth.performance.toDouble(),
          currentMonth.performance.toDouble(),
        ));
        chartData.add(ChartData(
          locale.get('Grades'),
          lastMonth.grades.toDouble(),
          currentMonth.grades.toDouble(),
        ));
        chartData.add(ChartData(
          locale.get('Understanding'),
          lastMonth.understanding.toDouble(),
          currentMonth.understanding.toDouble(),
        ));
        setIdle();
      },
    );
  }

  List<ChartData> chartData;
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x;
  final double y;
  final double y1;
}
