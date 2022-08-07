import 'dart:io';
import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/models/grade_model.dart';
import 'package:ts_academy/core/models/subject.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/teacher/add_courses/add_section/add_section.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/src/multipart_file.dart';
import 'package:flutter/material.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/main_ui_teacher.page.dart';
import 'package:ts_academy/ui/pages/teacher/teacher_home/teacher_home.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class AddCourseDataModel extends BaseNotifier {
  BuildContext context;
  FormGroup form;
  Course course;
  AddCourseDataModel({this.context, this.course}) {
    form = FormGroup(
      {
        'type': FormControl<String>(
          value: course?.type,
          validators: [
            Validators.required,
            Validators.composeOR([
              Validators.equals('session'),
              Validators.equals('tutorial'),
              Validators.equals('home')
            ])
          ],
        ),
        'subject': FormControl(
          value: course?.subject?.sId,
          validators: [
            Validators.required,
          ],
        ),
        'name': FormGroup({
          'ar': FormControl(
            value: course?.name?.ar,
            validators: [
              Validators.required,
            ],
          ),
          'en': FormControl(
            value: course?.name?.en,
            validators: [
              Validators.required,
            ],
          ),
        }),
        'cover': FormGroup({
          'ar': FormControl(
            value: course?.cover?.ar,
            validators: [
              Validators.required,
            ],
          ),
          'en': FormControl(
            value: course?.cover?.en,
            validators: [
              Validators.required,
            ],
          ),
        }),
        'info': FormGroup({
          'ar': FormControl(
            value: course?.info?.ar,
            validators: [
              Validators.required,
            ],
          ),
          'en': FormControl(
            value: course?.info?.en,
            validators: [
              Validators.required,
            ],
          ),
        }),
        'description': FormGroup({
          'ar': FormControl(
            value: course?.description?.ar,
            validators: [
              Validators.required,
            ],
          ),
          'en': FormControl(
            value: course?.description?.en,
            validators: [
              Validators.required,
            ],
          ),
        }),
        'price': FormControl<int>(
          value: course?.price,
          validators: [],
        ),
        'stage': FormControl<String>(
          value: course?.grade?.stage?.sId,
          validators: [
            Validators.required,
          ],
        ),
        'grade': FormControl(
          value: course?.grade?.sId,
          validators: [
            Validators.required,
          ],
        ),
        'days': FormArray<String>([], validators: []),
        'attachements': FormControl(validators: []),
        'startDate': FormControl<int>(
          validators: [Validators.required],
          value: course?.startDate,
        ),
        'teacher':
            FormControl(value: locator<AuthenticationService>().user.sId),
        'hour': FormControl<double>(
          value: course?.hour?.toDouble(),
          validators: [],
        ),
      },
    );
    if (course != null) {
      getGrades(context);
      // form.patchValue(course.toJson());
      // selectedSteps.addAll(course.days);
    }

    form.control('type').valueChanges.listen((value) {
      if (value == 'home') {
        form
            .control('price')
            .setValidators([Validators.required, Validators.min(0)]);
        form.control('price').patchValue(null);
      } else {
        form.control('price').clearValidators();
        form.control('price').patchValue(null);
      }
      if (value == 'tutorial') {
        form
            .control('days')
            .setValidators([Validators.required, Validators.minLength(1)]);
        form.control('days').patchValue(null);
        form.control('hour').setValidators([Validators.required]);
        form.control('hour').patchValue(null);
      } else {
        form.control('hour').clearValidators();
        form.control('hour').patchValue(null);
        form.control('days').clearValidators();
        form.control('days').patchValue(null);
      }
    });
    getStages(context);
    getSubject(context);
  }
  FormArray<String> get selectedSteps => form.control('days') as FormArray;
  List<Stage> stages = [];
  List<Grade> grades = [];
  List<Subject> subjects = [];
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

  void getGrades(context) async {
    setBusy();
    var res = await api.getGradesByStage(context,
        stageId: form.control('stage').value);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      grades = data.map<Grade>((item) => Grade.fromJson(item)).toList();
      setIdle();
      setState();
    });
  }

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

  String path;

  bool uploading = false;

  // uploadImage(String controllername) async {
  //   final locale = AppLocalizations.of(context);
  //   final pickedFile = await ImagePicker().pickImage(
  //       maxHeight: 800,
  //       maxWidth: 800,
  //       imageQuality: 80,
  //       source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState();
  //     var res = await api.uploadImage(context, image: pickedFile);
  //     res.fold((error) => UI.toast(error.toString()), (data) async {
  //       form.control(controllername).updateValue(data['id'].toString());

  //       setIdle();
  //       setState();
  //     });
  //     setState();
  //   } else {
  //     UI.toast(locale.get('No image selected') ?? "No image selected");
  //   }
  // }

//  chooseFile() async {
//     FilePickerResult result = await FilePicker.platform.pickFiles();

//     if (result != null) {
//       File file = File(result.files.single.path);
//       uploadFile(context, file.path);
//       print(file.path);
//       setState();
//     } else {
//       ErrorDialog().notification(
//         "Please upload your resum and cover letter",
//         Colors.red,
//       );
//     }
//   }

//   uploadFile(BuildContext context, result) async {
//     var res = await api.uploadFile(context, file: result);
//     res.fold((e) => UI.toast(e.message), (data) {
//       // Logger().wtf(data);

//         form.control("cover").value = data["id"];

//     });
//     setState();
//   }

  Course courseObject;
  void createCourse() async {
    final locale = AppLocalizations.of(context);
    var res = await api.createTeacherCourse(context, body: form.value);
    res.fold((error) {
      UI.toast(error.message);
    }, (data) {
      UI.showSnackBarMessage(
          context: context, message: locale.get('Course Added Successfully'));
      pushNewScreen(context, screen: const MainUITeacher(), withNavBar: false);

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => AddSectionPage(
      //         courseId: data["_id"].toString(),
      //         // course: courseObject,
      //       ),
      //     ));
      // Logger().w(data);
    });
  }

  void updateCourse() async {
    final locale = AppLocalizations.of(context);
    var res = await api.updateTeacherCourse(context,
        body: form.value, id: course.sId);
    res.fold((error) {
      UI.toast(error.message);
    }, (data) {
      UI.showSnackBarMessage(
          context: context, message: locale.get('Course Added Successfully'));
      pushNewScreen(context, screen: const MainUITeacher(), withNavBar: false);

      // courseObject = Course.fromJson(data);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => TeacherHome(
      //           // course: courseObject,
      //           ),
      //     ));
      // Logger().w(data);
    });
  }
}
