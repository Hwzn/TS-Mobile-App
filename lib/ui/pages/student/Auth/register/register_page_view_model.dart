import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/city_model.dart';
import 'package:ts_academy/core/models/grade_model.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/core/services/preference/preference.dart';
import 'package:ts_academy/ui/pages/student/Auth/verify_account/verify_account_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/MainHome/main_home_view.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/main_ui_teacher.page.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';

class StudentRegisterPageModel extends BaseNotifier {
  FormGroup form;

  bool isParent = false;
  BuildContext context;
  StudentRegisterPageModel(this.context) {
    getCity(context);
    getStages(context);
    form = FormGroup(
      {
        'name': FormControl(
          validators: [
            Validators.required,
            // Validators.composeOR(
            //     [Validators.email, Validators.pattern(phoneRegex)])
          ],
        ),
        'phone': FormControl(
          validators: [
            Validators.required,
            Validators.number,

            // Validators.pattern(
            //     r'^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$'),
            // Validators.composeOR(
            //     [Validators.email, Validators.pattern(phoneRegex)])
          ],
        ),
        'email': FormControl(
          validators: [
            Validators.required,
            Validators.email
            // Validators.composeOR(
            //     [Validators.email, Validators.pattern(phoneRegex)])
          ],
        ),
        'gradeId': FormControl<String>(
            validators: !isParent ? [Validators.required] : []),
        'stageId': FormControl<String>(
            validators: !isParent ? [Validators.required] : []),
        'cityId':
            FormControl(validators: !isParent ? [Validators.required] : []),
        'studentId':
            FormControl(validators: isParent ? [Validators.required] : []),
        'password': FormControl(
          validators: [
            Validators.required,
            Validators.minLength(8),
            Validators.maxLength(16),
            // Validators.pattern(r'^(?=.*[a-z])')
          ],
        ),
        "fcmToken": FormControl(value: Preference.getString(PrefKeys.fcmToken)),
        "defaultLang": FormControl(value: "en"),
      },
    );
  }

  List<Stage> stages = [];
  List<Grade> grades = [];
  List<City> cities = [];

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
    var res = await api.getGradesByStage(context,
        stageId: form.control('stageId').value);
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
      UI.toast(error.toString());
      setError();
    }, (data) {
      stages = data.map<Stage>((item) => Stage.fromJson(item)).toList();
      setIdle();
    });
  }

  User user;
  void studentRegister(contex) async {
    final AppLocalizations locale = AppLocalizations.of(context);
    setBusy();
    var res = await api.studentSignUp(context, body: form.value);
    res.fold((error) {
      ErrorDialog().notification(
        error.message.toString(),
        Colors.red,
      );
      setError();
    }, (data) {
      user = User.fromJson(data);
      locator<AuthenticationService>().saveUser(user);
      // UI.pushReplaceAll(context, VerifyAccountPage());
      locator<AuthenticationService>().loadUser;
      if (user.userType == "Student") {
        pushNewScreen(
          context,
          screen: MainUI(),
          pageTransitionAnimation: PageTransitionAnimation.slideUp,
        );
      } else if (user.userType == "Parent") {
        pushNewScreen(
          context,
          screen: MainUI(isParent: true),
          pageTransitionAnimation: PageTransitionAnimation.slideUp,
        );
      } else if (user.userType == "Teacher") {
        if (user.teacherApproved == true) {
          pushNewScreen(
            context,
            screen: const MainUITeacher(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
          );
        } else {
          pushNewScreen(
            context,
            screen: const MainUITeacher(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
          );
          UI.showSnackBarMessage(
              context: context,
              message: locale.get('Please wait until approve your account'));
        }
      }
      setIdle();
    });
  }

  void parentRegister(contex) async {
    setBusy();
    var res = await api.parentSignUp(context, body: form.value);
    res.fold((error) {
      ErrorDialog().notification(
        error.message.toString(),
        Colors.red,
      );
      setError();
    }, (data) {
      user = User.fromJson(data);
      locator<AuthenticationService>().saveUser(user);
      pushNewScreen(context,
          screen: VerifyAccountPage(),
          pageTransitionAnimation: PageTransitionAnimation.slideUp,
          withNavBar: false);
      setIdle();
    });
  }
}
