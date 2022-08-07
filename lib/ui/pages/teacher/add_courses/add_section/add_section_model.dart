import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/main_ui_teacher.page.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';
import 'package:ts_academy/ui/routes/ui.dart';

import 'add_section.dart';

class AddSectionPageModel extends BaseNotifier {
  BuildContext context;
  FormGroup form;
  Course courseObject;
  FormGroup lessonFormGroup = new FormGroup({
    "OId": FormControl(),
    "name": FormControl(),
    "type": FormControl<String>(value: "video"),
    "attachement": FormControl(value: null),
  });
  FormGroup chapterFormGroup;
  List<Map<String, dynamic>> sections;
  SingingCharacter isExercise = SingingCharacter.exercise;

  AddSectionPageModel({this.courseObject}) {
    chapterFormGroup = new FormGroup({
      "OId": FormControl(),
      "chapter": FormControl(),
      "lessons": FormArray([])
    });
    form = FormGroup({
      "courses": FormArray([chapterFormGroup])
    });

    if (courseObject != null) {
      courses.removeAt(0, updateParent: true, emitEvent: true);
      // courseObject.content.forEach((element) {
      //   courses.add(new FormGroup({
      //     "OId": FormControl(value: element.oId),
      //     "chapter": FormControl(
      //         value: element.chapter, validators: [Validators.required]),
      //     "lessons": FormArray(element.lessons.map((lesson) {
      //       return new FormGroup({
      //         // "OId": FormControl(value: lesson.oId),
      //         "name": FormControl(
      //             value: lesson.name, validators: [Validators.required]),
      //         "type": FormControl<String>(
      //             value: lesson.type, validators: [Validators.required]),
      //         "attachement": FormControl(
      //             value: lesson.attachement,
      //             validators: [
      //               lesson.type == "excersise"
      //                   ? Validators.required
      //                   : Validators.maxLength(9999)
      //             ])
      //       });
      //     }).toList())
      //   }));
      // });
    }
    // Logger().w(courses.value);
  }
  FormArray get courses => form.control('courses') as FormArray;

  void addCourse() {
    courses.add(FormGroup({
      "OId": FormControl(),
      "chapter": FormControl(),
      "lessons": FormArray([])
    }));
  }

  createContent(FormGroup courseControl) {
    FormArray lessons = courseControl.control('lessons') as FormArray;
    lessons.add(FormGroup({
      "OId": FormControl(),
      "name": FormControl(),
      "type": FormControl<String>(value: "video"),
      "attachement": FormControl(value: null)
    }));

    setState();
    print(lessons);
  }

  void removeContent(int courseIndex, int lessonIndex) {
    FormGroup courseFormGroup = courses.controls[courseIndex];
    FormArray lessonsFormArray = courseFormGroup.control('lessons');
    lessonsFormArray.removeAt(lessonIndex, updateParent: true, emitEvent: true);
    setState();
  }

  void removeChapter(int chapterIndex) {
    courses.removeAt(chapterIndex, updateParent: true, emitEvent: true);
    setState();
  }

  chooseFile(int chapterIndex, int lessonIndex) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      uploadFile(context, file.path, chapterIndex, lessonIndex);
      print(file.path);

      setState();
    } else {
      const ErrorDialog().notification(
        "Please upload your resum and cover letter",
        Colors.red,
      );
    }
  }

  String fileId;
  uploadFile(
      BuildContext context, result, int chapterIndex, int lessonIndex) async {
    var res = await api.uploadFile(context, file: result);
    res.fold((e) => UI.toast(e.message), (data) {
      // Logger().wtf(data);
      fileId = data["id"];
      FormGroup chatperForm = courses.controls[chapterIndex];
      FormArray lessons = chatperForm.control('lessons');
      FormGroup lessonGroup = lessons.controls[lessonIndex];
      lessonGroup.control('attachement').patchValue({
        "id": data["id"],
        "path": data["path"],
        "name": data["name"],
        "mimetype": data["mimetype"]
      });
    });
    setState();
  }

  void createCoursrContent(String id, ctx) async {
    // Logger().wtf(courses.value);
    var res = await api.createTeacherCourseContent(context,
        body: courses.value.toList(), courseId: id);
    res.fold((error) {
      UI.toast(error.message);
    }, (data) {
      // Logger().wtf(data);
      UI.pushReplaceAll(ctx, MainUITeacher());
    });
  }
}
