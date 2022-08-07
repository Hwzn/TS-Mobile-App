import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/models/server_error.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/video/call.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';

class StartLiveModel extends BaseNotifier {
  final BuildContext context;

  Course selectedCourse;
  Content selectedChapter;
  Lessons selectedLesson;

  StartLiveModel(this.context) {
    getMyCourses(context);
  }
  List<Course> _courses = [];
  List<Course> get courses => [..._courses];

  getMyCourses(context) async {
    setBusy();
    try {
      final response = await api.getTeacherCourses(context);
      response.fold((error) {
        // Logger().e(error.message);
      }, (data) {
        // Logger().d(data);
        _courses
            .addAll(List.from(data).map((e) => Course.fromJson(e)).toList());
        _courses = _courses
            .where((element) =>
                element.type != 'home' &&
                element.startDate >= DateTime.now().millisecondsSinceEpoch)
            .toList();
        setState();
      });
    } catch (e) {
      // Logger().e(e.message);
    }
    setIdle();
  }

  void showAlertDialog(BuildContext context) {
    final locale = AppLocalizations.of(context);
    String userType = locator<AuthenticationService>().user.userType;

    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          locale.get(userType == 'Teacher' ? "Start live" : "Join Live"),
          style: const TextStyle(color: AppColors.red),
        ),
        content: Text(locale.get(userType == 'Teacher'
            ? "are you sure you want to start live"
            : "are you sure you want to join live")),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(locale.get("Cancel")),
          ),
          CupertinoDialogAction(
            isDefaultAction: false,
            isDestructiveAction: true,
            onPressed: () async {
              var result;

              setBusy();
              switch (userType) {
                case 'Teacher':
                  result = await api.startLive(
                    context,
                    body: {
                      "token":
                          "Bearer ${locator<AuthenticationService>().user.token}",
                      "courseId": selectedCourse.sId,
                    },
                  );
                  break;

                case 'Student':
                  result = await api.joinLive(
                    context,
                    body: {
                      "token":
                          "Bearer ${locator<AuthenticationService>().user.token}",
                      "courseId": selectedCourse.sId,
                    },
                  );
                  break;
                default:
                  break;
              }
              setIdle();

              if (result != null) {
                result.fold((ServerError e) {
                  Navigator.pop(context);
                  const ErrorDialog().notification(
                    locale.get(e.message),
                    Colors.redAccent,
                  );
                }, (d) async {
                  // Logger().d(d);
                  dynamic liveToken = userType == 'Teacher'
                      ? d["teacherToken"]
                      : d["studentToken"];
                  Navigator.pop(context);

                  UI.push(
                    context,
                    CallPage(
                        // lesssonId: lessonId,
                        // courseId: model.courseId,
                        // role: ClientRole.Broadcaster,
                        course: this.selectedCourse,
                        liveToken: liveToken),
                  );
                });
              }
            },
            child: Text(locale.get("Confirm")),
          ),
        ],
      ),
    );
  }

  endLive(String courseId) async {
    final locale = AppLocalizations.of(context);
    setBusy();
    var result = await api.endLive(
      context,
      body: {
        "token": "Bearer ${locator<AuthenticationService>().user.token}",
        "courseId": courseId
      },
    );
    if (result != null) {
      result.fold((ServerError e) {
        const ErrorDialog().notification(
          locale.get(e.message),
          Colors.redAccent,
        );
      }, (d) async {
        // Logger().d(d);

        return d;
      });
    }
    return null;
  }

  leave(String courseId) async {
    final locale = AppLocalizations.of(context);
    setBusy();
    var result = await api.leave(
      context,
      body: {
        "token": "Bearer ${locator<AuthenticationService>().user.token}",
        "courseId": courseId
      },
    );
    if (result != null) {
      return result.fold((ServerError e) {
        ErrorDialog().notification(
          locale.get(e.message),
          Colors.redAccent,
        );
      }, (d) async {
        // Logger().d(d);

        return d;
      });
    }
    return null;
  }
}
