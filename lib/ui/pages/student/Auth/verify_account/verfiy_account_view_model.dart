import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/change_password/change_password_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/MainHome/main_home_view.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/main_ui_teacher.page.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class VerifyAccountPageModel extends BaseNotifier {
  FormGroup form;

  User user;
  void activateUser(context, String code, bool resetPassword) async {
    final locale = AppLocalizations.of(context);
    setBusy();
    var res = await api.userActivate(context, code: code);
    res.fold((error) {
      setError();
      ErrorDialog().notification(
        error.message.toString(),
        Colors.red,
      );
    }, (data) {
      user = User.fromJson(data);
      locator<AuthenticationService>().saveUser(user);
      // Logger().w(data);
      if (resetPassword) {
        UI.pushReplaceAll(context, StudentChangePasswordPage());
      } else {
        if (user.userType == "Student") {
          UI.pushReplaceAll(context, MainUI());
        } else if (user.userType == "Parent") {
          UI.pushReplaceAll(
              context,
              MainUI(
                isParent: true,
              ));
        } else if (user.userType == "Teacher") {
          if (user.teacherApproved == true)
            UI.pushReplaceAll(context, MainUITeacher());
          else {
            UI.pushReplaceAll(context, MainUITeacher());
            UI.showSnackBarMessage(
                context: context,
                message: locale.get('Please wait until approve your account'));
          }
        }
      }
      setIdle();
    });
  }

  void resendCode(context) async {
    var res = await api.resendCode(context);
    res.fold((error) {
      UI.toast(error.toString());
    }, (data) {
      UI.toast("Done");
    });
  }
}
