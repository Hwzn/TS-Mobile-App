import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/teacher/add_courses/add_section/add_section_model.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/custom/section_custom_shape.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';

enum SingingCharacter { exercise, video }

class AddSectionPage extends StatefulWidget {
  String courseId;
  Course course;
  AddSectionPage({this.courseId, this.course});
  @override
  _AddSectionPageState createState() => _AddSectionPageState();
}

class _AddSectionPageState extends State<AddSectionPage> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<AddSectionPageModel>(
        create: (context) => AddSectionPageModel(courseObject: widget.course),
        child: Consumer<AddSectionPageModel>(builder: (context, model, __) {
          return SafeArea(
              child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReactiveForm(
                formGroup: model.form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: SizeConfig.heightMultiplier * 8,
                        child: Center(
                          child: Text(
                            locale.get('Create Content'),
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2.5,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          model.form.markAllAsTouched();
                          if (model.form.valid) {
                            setState(() {
                              model.addCourse();
                            });
                          }
                        },
                        child: Container(
                          width: SizeConfig.widthMultiplier * 90,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: CustomSectionContainer(
                                SizeConfig.widthMultiplier * 34,
                                SizeConfig.heightMultiplier * 5),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 3,
                      ),
                      ...model.courses.controls.map((courseControl) {
                        FormGroup courseFormCountrol = courseControl;
                        FormArray lessons =
                            courseFormCountrol.control('lessons') as FormArray;
                        var chapterIndex =
                            model.courses.controls.indexOf(courseFormCountrol);
                        return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Theme(
                              data: ThemeData().copyWith(
                                  dividerColor: Colors.transparent,
                                  cardColor: Colors.white,
                                  shadowColor: Colors.black),
                              child: ExpansionTile(
                                key: Key('$chapterIndex'),
                                maintainState: true,
                                childrenPadding: const EdgeInsets.all(20),
                                tilePadding: const EdgeInsets.all(8),
                                title: ReactiveForm(
                                    formGroup: courseControl,
                                    child: Container(
                                        width: SizeConfig.widthMultiplier * 80,
                                        child: ReactiveField(
                                          decoration: InputDecoration(
                                            // fillColor:
                                            //     AppColors.primaryColor,
                                            // filled: true,
                                            hintText:
                                                locale.get('Chapter Title'),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.1),
                                              borderSide: const BorderSide(
                                                  color: Colors.black26,
                                                  width: 0.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.black26,
                                                  width: 0.5),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.black26,
                                                  width: 0.5),
                                            ),
                                          ),
                                          textColor: AppColors.greyColor,
                                          borderColor: AppColors.borderColor,
                                          validationMesseges: {
                                            'required':
                                                locale.get('Must not be empty'),
                                          },
                                          width:
                                              SizeConfig.widthMultiplier * 30,
                                          enabledBorderColor:
                                              AppColors.borderColor,
                                          hintColor: Colors.black,
                                          type: ReactiveFields.TEXT,
                                          controllerName: 'chapter',
                                          label: locale.get('Chapter Name'),
                                        ))),
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                      color: AppColors
                                                          .primaryColor),
                                                  ),
                                                  onPressed: () {
                                                    model.removeChapter(
                                                        chapterIndex);
                                                    // Navigator.pushAndRemoveUntil(
                                                  },
                                                  child: Text(
                                                    locale
                                                        .get('Delete Chapter'),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  )),
                                            ),
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  model.createContent(
                                                      courseControl);
                                                  // Navigator.pushAndRemoveUntil(
                                                },
                                                child: Text(
                                                  locale.get('Add Lesson'),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                )),
                                          )
                                        ],
                                      ),
                                      ...lessons.controls.map((lessonControl) {
                                        FormGroup lessonFromControl =
                                            lessonControl;
                                        int lessonIndex = lessons.controls
                                            .indexOf(lessonFromControl);

                                        // return Text(lessonFromControl.value.toString());
                                        return ReactiveForm(
                                          formGroup: lessonFromControl,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: ExpansionTile(
                                                key: Key(
                                                    '${chapterIndex}_$lessonIndex'),
                                                maintainState: true,
                                                childrenPadding:
                                                    const EdgeInsets.all(20),
                                                tilePadding:
                                                    const EdgeInsets.all(8),
                                                leading: lessonFromControl
                                                            .control('type')
                                                            .value ==
                                                        'video'
                                                    ? const Icon(
                                                        Icons.play_arrow)
                                                    : const Icon(Icons.alarm),
                                                title: ReactiveField(
                                                  textColor:
                                                      AppColors.greyColor,
                                                  borderColor:
                                                      AppColors.borderColor,
                                                  validationMesseges: {
                                                    'required': locale.get(
                                                        'Must not be empty'),
                                                  },
                                                  enabledBorderColor:
                                                      AppColors.borderColor,
                                                  hintColor: Colors.black,
                                                  type: ReactiveFields.TEXT,
                                                  controllerName: 'name',
                                                  label:
                                                      locale.get('Lesson Name'),
                                                ),
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ListTile(
                                                          title: Text(locale.get(
                                                              'Live Video')),
                                                          leading: Radio(
                                                            value: "video",
                                                            groupValue:
                                                                lessonFromControl
                                                                    .control(
                                                                        "type")
                                                                    .value,
                                                            onChanged: (value) {
                                                              lessonFromControl
                                                                  .control(
                                                                      "type")
                                                                  .value = value;
                                                              model.setState();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ListTile(
                                                          title: Text(
                                                              locale.get(
                                                                  'excercice')),
                                                          leading: Radio(
                                                            value: "excercice",
                                                            groupValue:
                                                                lessonFromControl
                                                                    .control(
                                                                        "type")
                                                                    .value,
                                                            onChanged: (value) {
                                                              lessonFromControl
                                                                  .control(
                                                                      "type")
                                                                  .value = value;
                                                              model.setState();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  lessonFromControl
                                                              .control('type')
                                                              .value ==
                                                          'excercice'
                                                      ? Column(
                                                          children: [
                                                            Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(locale.get(
                                                                        'Upload Attachement')),
                                                                    InkWell(
                                                                        onTap:
                                                                            () {
                                                                          model.chooseFile(
                                                                              chapterIndex,
                                                                              lessonIndex);
                                                                        },
                                                                        child: const Icon(
                                                                            Icons.attachment_outlined))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const Divider(),
                                                            lessonFromControl
                                                                        .control(
                                                                            "attachement")
                                                                        .value !=
                                                                    null
                                                                ? Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "${lessonFromControl.control("attachement").value != null ? lessonFromControl.control("attachement").value['name'] : '' ?? ""} ",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText2
                                                                              .copyWith(color: AppColors.primaryColor, fontSize: SizeConfig.textMultiplier * 1.5),
                                                                        ),
                                                                        InkWell(
                                                                            onTap:
                                                                                () {
                                                                              lessonFromControl.control("attachement").reset();

                                                                              model.setState();
                                                                            },
                                                                            child:
                                                                                const Icon(
                                                                              Icons.delete,
                                                                              color: Colors.red,
                                                                            ))
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    locale.get(
                                                                        'Required'),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                          side: const BorderSide(
                                                            color: AppColors
                                                                .primaryColor),
                                                        ),
                                                        onPressed: () {
                                                          model.removeContent(
                                                              chapterIndex,
                                                              lessonIndex);
                                                          // Navigator.pushAndRemoveUntil(
                                                        },
                                                        child: Text(
                                                          locale.get('Delete'),
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .primaryColor,
                                                              fontSize: 16),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                  )
                                ],
                                collapsedBackgroundColor:
                                    const Color.fromRGBO(57, 169, 199, 0.06),
                                initiallyExpanded: true,
                                // backgroundColor:
                                //     Color.fromRGBO(57, 169, 199, 0.06),
                              ),
                            ));
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      ReactiveFormConsumer(
                        builder: (context, form, child) {
                          return NormalButton(
                              color: form.valid
                                  ? AppColors.primaryColor
                                  : Colors.blueGrey,
                              onPressed: () {
                                if (form.valid) {
                                  model.createCoursrContent(
                                      widget.courseId, context);
                                } else {
                                  print('invalid');
                                }
                                // Logger().wtf(model.form.value);
                              },
                              child: Text(
                                locale.get('Create Content'),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
        }));
  }

  Padding sectionWidget(Map<String, dynamic> e, AddSectionPageModel model) {
    final locale = AppLocalizations.of(model.context);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ExpansionTile(
        children: [
          ...e['lessons']
              .map(
                (lessons) => lessonsWidget(lessons),
              )
              .toList(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ReactiveForm(
              formGroup: model.form,
              child: Column(
                children: [
                  ReactiveField(
                    textColor: AppColors.greyColor,
                    borderColor: AppColors.borderColor,
                    validationMesseges: {
                      'required': locale.get('Must not be empty'),
                    },
                    enabledBorderColor: AppColors.borderColor,
                    hintColor: Colors.black,
                    type: ReactiveFields.TEXT,
                    controllerName: 'lessons',
                    label: locale.get('Lesson Title'),
                  ),
                  Container(
                    height: SizeConfig.heightMultiplier * 5,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<SingingCharacter>(
                            groupValue: model.isExercise,
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(locale.get('Exercise')),
                            onChanged: (val) {
                              setState(() {
                                model.isExercise = val;
                              });
                            },
                            value: SingingCharacter.exercise,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<SingingCharacter>(
                            contentPadding: const EdgeInsets.all(0),
                            groupValue: model.isExercise,
                            title: Text(locale.get('Live Video')),
                            onChanged: (val) {
                              setState(() {
                                model.isExercise = val;
                              });
                            },
                            value: SingingCharacter.video,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.blueAccent[100],
                side: BorderSide(color: Colors.blueAccent[100], width: 2),
              ),
              onPressed: () {
                model.form.markAllAsTouched();
                if (model.form.valid) {
                  setState(() {
                    e['lessons'].add({
                      'content': model.form.value['lessons'],
                      'type': model.isExercise
                    });
                    model.form.control('lessons').reset();
                  });
                }
              },
              child: Container(
                  width: SizeConfig.widthMultiplier * 30,
                  height: SizeConfig.heightMultiplier * 6,
                  child: Center(
                      child: Text(
                    locale.get('Add Lesson'),
                  ))),
            ),
          ),
        ],
        maintainState: true,
        initiallyExpanded: e['isExpanded'],
        onExpansionChanged: (value) {
          model.sections.forEach((element) {
            element['isExpanded'] = false;
          });
          setState(() {
            e['isExpanded'] = value;
          });
        },
        title: Container(
          height: SizeConfig.heightMultiplier * 5,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Text(
            e['title'] ?? "",
            style: const TextStyle(color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Text(
          locale.get('Create Chapter'),
          style: const TextStyle(color: Colors.lightBlueAccent),
        ),
      ),
    );
  }

  Padding lessonsWidget(lessons) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
      child: Container(
        height: SizeConfig.heightMultiplier * 4,
        width: double.infinity,
        child: Text(
          lessons['content'] ?? "",
          style: const TextStyle(color: AppColors.greyColor),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
