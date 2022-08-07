import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:intl/intl.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';

import '../../../../../../core/models/course.dart';
import '../../../../../../core/services/localization/localization.dart';
import '../../../../../routes/ui.dart';

class SchedulePageModel extends BaseNotifier {
  final BuildContext context;
  final AppLocalizations locale;
  CalendarWeekController calendarWeekController = CalendarWeekController();
  List<Course> coursesList = [];
  String monthYear;

  SchedulePageModel(this.context, this.locale) {
    getCoursesByDay(DateTime.now().millisecondsSinceEpoch);
    onWeekChanged(DateTime.now());
  }

  void getCoursesByDay(int timeStamp) async {
    onWeekChanged(DateTime.fromMillisecondsSinceEpoch(timeStamp));
    setBusy();
    final res = await api.getCaurseByDate(context, timeStamp: timeStamp);
    res.fold((error) {
      UI.showSnackBarMessage(context: context, message: "${error.message}");
      setError();
    }, (data) {
      if (data != null) {
        coursesList = data.map<Course>((e) => Course.fromJson(e)).toList();
        print("=======>>>> $data <<<=========");
        setState();
      }
      setIdle();
    });
  }

  void onWeekChanged(DateTime dateTime) {
    monthYear = DateFormat("MMM").format(dateTime) +
        " " +
        DateFormat("yyy").format(dateTime);
  }
}
