import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/preference/preference.dart';

import 'package:ts_academy/ui/pages/student/Auth/verify_account/verify_account_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/MainHome/main_home_view.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/main_ui_teacher.page.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class StudentLoginPageModel extends BaseNotifier {
  FormGroup form;

  bool isParent = false;
  StudentLoginPageModel() {
    form = FormGroup(
      {
        'username': FormControl(
          validators: [
            Validators.required,
            // Validators.composeOR(
            //     [Validators.email, Validators.pattern(phoneRegex)])
          ],
        ),
        'studentId': FormControl(),
        'password': FormControl(
          validators: [
            Validators.required,
            Validators.minLength(8),
            // Validators.maxLength(16),
            // Validators.pattern(r'^(?=.*[a-z])')
          ],
        ),
        "fcmToken": FormControl(value: Preference.getString(PrefKeys.fcmToken)),
        "defaultLang": FormControl(value: "en"),
      },
    );
  }

  User user;
  void login(context) async {
    setBusy();
    var res = await api.signin(context, body: form.value);
    print(form.value);
    res.fold((error) {
      setError();
      ErrorDialog().notification(
        error.message.toString(),
        Colors.red,
      );
    }, (data) async {
      user = User.fromJson(data);
      locator<AuthenticationService>().saveUser(user);
      var camera = await Permission.camera.request();
      if (camera.isDenied) {
        camera = await Permission.camera.request();
        if (camera.isDenied) Navigator.pop(context);
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
      }

      var mic = await Permission.microphone.request();
      if (mic.isDenied) {
        mic = await Permission.microphone.request();
        if (mic.isDenied) Navigator.pop(context);
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
      }
      if (user.isActive) {
        if (user.userType == "Student") {
          pushNewScreen(
            context,
            screen: MainUI(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
          );
        } else if (user.userType == "Teacher") {
          pushNewScreen(
            context,
            screen: MainUITeacher(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
          );
        } else if (user.userType == "Parent") {
          pushNewScreen(
            context,
            screen: MainUI(
              isParent: true,
            ),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
          );
        }
      } else {
        pushNewScreen(
          context,
          screen: VerifyAccountPage(),
          pageTransitionAnimation: PageTransitionAnimation.slideUp,
        );
      }
      setIdle();
    });
  }
}
