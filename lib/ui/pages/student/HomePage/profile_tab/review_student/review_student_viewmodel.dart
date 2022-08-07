import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/review_model.dart';
import 'package:ts_academy/core/models/subject.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/statistics/statistics_viewmodel.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import '../../../../../../core/services/localization/localization.dart';

class ReviewStudentPageModel extends BaseNotifier {
  final BuildContext context;
  final AppLocalizations locale;
  final User student;
  final String courseId;
  FormGroup form;
  String lastMonthKey;
  String currentMonthKey;
  ReviewModel lastMonth;
  ReviewModel currentMonth;
  AuthenticationService auth;
  final Subject subject;

  ReviewStudentPageModel(
      this.context, this.locale, this.student, this.courseId, this.subject) {
    form = FormGroup({
      "attendance":
          FormControl<bool>(value: false, validators: [Validators.required]),
      "performance": FormControl<int>(validators: [
        Validators.required,
        Validators.min(0),
        Validators.max(100)
      ]),
      "grades": FormControl<int>(validators: [
        Validators.required,
        Validators.min(0),
        Validators.max(100)
      ]),
      "understanding": FormControl<int>(validators: [
        Validators.required,
        Validators.min(0),
        Validators.max(100)
      ]),
    });

    auth = locator<AuthenticationService>();

    chartDataList = [
      ChartData(locale.get('Attendees'), 0, 0),
      ChartData(locale.get('performance'), 0, 0),
      ChartData(locale.get('Grades'), 0, 0),
      ChartData(locale.get('Understanding'), 0, 0),
    ];
    getStudentReview();
    lastMonthKey = DateFormat("MM-yyy")
        .format(DateTime.now().subtract(Duration(days: 30)));
    currentMonthKey = DateFormat("MM-yyy").format(DateTime.now());
  }

  List<ChartData> chartDataList;

  void getStudentReview() async {
    setBusy();
    final res = await api.getStudentReview(
      context,
      studentId: student.sId,
      subjectId: subject.sId,
    );
    res.fold(
      (e) => UI.showSnackBarMessage(context: context, message: e.toString()),
      (data) {
        lastMonth = ReviewModel.fromJson(data[lastMonthKey]);
        currentMonth = ReviewModel.fromJson(data[currentMonthKey]);
        chartDataList.clear();
        chartDataList.add(ChartData(
          locale.get('Attendees'),
          lastMonth.attendance.toDouble(),
          currentMonth.attendance.toDouble(),
        ));
        chartDataList.add(ChartData(
          locale.get('performance'),
          lastMonth.performance.toDouble(),
          currentMonth.performance.toDouble(),
        ));
        chartDataList.add(ChartData(
          locale.get('Grades'),
          lastMonth.grades.toDouble(),
          currentMonth.grades.toDouble(),
        ));
        chartDataList.add(ChartData(
          locale.get('Understanding'),
          lastMonth.understanding.toDouble(),
          currentMonth.understanding.toDouble(),
        ));
        setIdle();
      },
    );
  }

  Future<void> addReviewStudent() async {
    setBusy();
    final res = await api.addReviewStudent(
      context,
      body: form.value,
      studentId: student.sId,
      courseId: courseId,
    );
    res.fold(
      (e) => UI.showSnackBarMessage(context: context, message: e.toString()),
      (data) {
        if (data != null) {
          UI.showSnackBarMessage(
              context: context,
              message: locale.get('Student Reviewed Successfllty'));
          setIdle();
        } else {
          setError();
        }
      },
    );
  }
}
