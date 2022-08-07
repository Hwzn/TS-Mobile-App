import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/city_model.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';

import 'package:ts_academy/core/services/preference/preference.dart';
import 'package:ts_academy/ui/pages/student/Auth/verify_account/verify_account_view.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:file_picker/file_picker.dart';

class TeacherRegisterPageModel extends BaseNotifier {
  FormGroup form;
  BuildContext context;
  TeacherRegisterPageModel() {
    form = FormGroup({
      'name': FormControl(
        validators: [
          Validators.required,
        ],
      ),
      'phone': FormControl(
        validators: [
          Validators.required,
          Validators.number,
          Validators.pattern(
              r'^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$'),
        ],
      ),
      'coverLetter': FormControl(
        validators: [
          Validators.required,
        ],
      ),
      'resume': FormControl(
        validators: [
          Validators.required,
        ],
      ),
      'additionalPhone': FormControl(
        validators: [
          Validators.required,
          Validators.number,
          Validators.pattern(
              r'^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$'),
        ],
      ),
      'email': FormControl(
        validators: [Validators.required, Validators.email],
      ),
      'cityId': FormControl(
        validators: [
          Validators.required,
        ],
      ),
      'password': FormControl(
        validators: [
          Validators.required,
          Validators.minLength(8),
          Validators.maxLength(16),
          Validators.pattern(r'^(?=.*[a-z])')
        ],
      ),
      'confirmPassword': FormControl(
        validators: [
          Validators.required,
          Validators.minLength(8),
          Validators.maxLength(16),
          Validators.pattern(r'^(?=.*[a-z])')
        ],
      ),
      "fcmToken": FormControl(value: Preference.getString(PrefKeys.fcmToken)),
      "defaultLang": FormControl(value: "en"),
    }, validators: [
      Validators.mustMatch('password', 'confirmPassword')
    ]);
    getCity(context);
  }

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

  String resumeName;
  String resumeSize;
  String coverLetterName;
  String coverLetterSize;

  chooseFile(bool resume) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      uploadFile(context, file.path, resume);
      print(file.path);
      if (resume) {
        resumeName = result.files[0].name.toString();
        resumeSize = "${((result.files[0].size / 1000).toInt())} KB";
      } else {
        coverLetterName = result.files[0].name.toString();
        resumeSize = "${((result.files[0].size / 1000).toInt())} KB";
      }
      setState();
    } else {
      ErrorDialog().notification(
        "Please upload your resum and cover letter",
        Colors.red,
      );
    }
  }

  uploadFile(BuildContext context, result, bool resume) async {
    var res = await api.uploadFile(context, file: result);
    res.fold((e) => UI.toast(e.message), (data) {
      // Logger().wtf(data);
      if (resume) {
        form.control("resume").value = data["id"];
      } else {
        form.control("coverLetter").value = data["id"];
      }
    });
    setState();
  }

  User user;
  void teacherRegister(contex) async {
    setBusy();
    var res = await api.teacherSignUp(context, body: form.value);
    res.fold((error) {
      ErrorDialog().notification(
        error.message.toString(),
        Colors.red,
      );
      setError();
    }, (data) {
      user = User.fromJson(data);
      locator<AuthenticationService>().saveUser(user);
      UI.pushReplaceAll(contex, VerifyAccountPage());
      setIdle();
    });
  }
}
