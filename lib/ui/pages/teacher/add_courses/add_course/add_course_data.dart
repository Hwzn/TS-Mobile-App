import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/cached_image.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ts_academy/ui/widgets/single-image-upload.widget.dart';

import 'add_course_data_model.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddCourseData extends StatelessWidget {
  Course course;
  AddCourseData({this.course});
  List<String> days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  List hours = [
    12.00,
    12.30,
    01.00,
    1.30,
    2.00,
    2.30,
    3.00,
    3.30,
    4.00,
    4.30,
    5.00,
    5.30,
    6.00,
    6.30,
    7.00,
    7.30,
    8.00,
    8.30,
    9.00,
    9.30,
    10.00,
    10.30,
    11.00,
    11.30
  ];
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<AddCourseDataModel>(
        create: (context) =>
            AddCourseDataModel(context: context, course: course),
        child: Consumer<AddCourseDataModel>(builder: (context, model, __) {
          return Scaffold(
            appBar: AppBar(
              title: Text(locale.get('Create Course'),
                  style: TextStyle(color: AppColors.primaryText)),
              leading: const BackButton(color: AppColors.primaryText),
              backgroundColor: AppColors.primaryBackground,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ReactiveForm(
                formGroup: model.form,
                child: ListView(
                  children: [
                    Text(locale.get('Select Course Type'),
                        style: Theme.of(context).textTheme.bodyText1),
                    ReactiveValueListenableBuilder<String>(
                      formControlName: 'type',
                      builder: (context, control, child) {
                        return ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 70),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    control.updateValue('home');
                                  },
                                  child: Chip(
                                    elevation: 2,
                                    backgroundColor: control.value == 'home'
                                        ? AppColors.ternaryBackground
                                        : AppColors.primaryColor,
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    label: Text(locale.get('At Home'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(color: Colors.white)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    control.updateValue('session');
                                  },
                                  child: Chip(
                                    elevation: 2,
                                    backgroundColor: control.value == 'session'
                                        ? AppColors.ternaryBackground
                                        : AppColors.primaryColor,
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    label: Text(
                                        locale.get('One Online Session'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(color: Colors.white)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    control.updateValue('tutorial');
                                  },
                                  child: Chip(
                                    elevation: 2,
                                    backgroundColor: control.value == 'tutorial'
                                        ? AppColors.ternaryBackground
                                        : AppColors.primaryColor,
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    label: Text(
                                        locale.get('Multiple Online Sessions'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReactiveField(
                      context: context,
                      borderColor: AppColors.borderColor,
                      enabledBorderColor: AppColors.borderColor,
                      hintColor: AppColors.borderColor,
                      textColor: AppColors.greyColor,
                      items: model.stages,
                      type: ReactiveFields.DROP_DOWN,
                      controllerName: 'stage',
                      label: locale.get('Stage'),
                      onchange: (value) {
                        print(value);
                        model.getGrades(context);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReactiveValueListenableBuilder<String>(
                      formControlName: 'stage',
                      builder: (context, control, child) {
                        return control.valid
                            ? ReactiveField(
                                context: context,
                                borderColor: AppColors.borderColor,
                                enabledBorderColor: AppColors.borderColor,
                                hintColor: AppColors.borderColor,
                                textColor: AppColors.greyColor,
                                items: model.grades,
                                type: ReactiveFields.DROP_DOWN,
                                controllerName: 'grade',
                                label: locale.get('Grade'))
                            : const SizedBox();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ReactiveField(
                          context: context,
                          borderColor: AppColors.borderColor,
                          enabledBorderColor: AppColors.borderColor,
                          hintColor: AppColors.borderColor,
                          textColor: AppColors.greyColor,
                          items: model.subjects,
                          isObject: true,
                          type: ReactiveFields.DROP_DOWN,
                          controllerName: 'subject',
                          label: locale.get('Subject')),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Course Image'),
                            ),
                            SingleImageUpload(
                              width: SizeConfig.widthMultiplier * 40,
                              height: SizeConfig.widthMultiplier * 40,
                              form: model.form,
                              imageController: 'cover.en',
                              afterUpload: () => model.setState(),
                              placeholder: const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.lightBlueAccent,
                              ),
                              title: 'Course Image',
                            )
                          ],
                        ),
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('صورة تعريفية'),
                            ),
                            SingleImageUpload(
                              width: SizeConfig.widthMultiplier * 40,
                              height: SizeConfig.widthMultiplier * 40,
                              form: model.form,
                              imageController: 'cover.ar',
                              afterUpload: () => model.setState(),
                              placeholder: const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.lightBlueAccent,
                              ),
                              title: 'صورة تعريفية',
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ReactiveField(
                        context: context,
                        borderColor: AppColors.borderColor,
                        enabledBorderColor: AppColors.borderColor,
                        hintColor: AppColors.borderColor,
                        textColor: AppColors.greyColor,
                        // items: ["5", "4", "3", "2", "1"],
                        type: ReactiveFields.TEXT,
                        textDirection: TextDirection.rtl,
                        controllerName: 'name.ar',
                        label: 'اسم الدورة',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ReactiveField(
                        context: context,
                        borderColor: AppColors.borderColor,
                        enabledBorderColor: AppColors.borderColor,
                        hintColor: AppColors.borderColor,
                        textColor: AppColors.greyColor,
                        // items: ["5", "4", "3", "2", "1"],
                        type: ReactiveFields.TEXT,
                        textDirection: TextDirection.ltr,

                        controllerName: 'name.en',
                        label: 'Course Name',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ReactiveField(
                        context: context,
                        borderColor: AppColors.borderColor,
                        enabledBorderColor: AppColors.borderColor,
                        hintColor: AppColors.borderColor,
                        textColor: AppColors.greyColor,
                        // items: ["5", "4", "3", "2", "1"],
                        type: ReactiveFields.TEXT,
                        textDirection: TextDirection.rtl,

                        controllerName: 'info.ar',
                        label: 'معلومات',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ReactiveField(
                        context: context,
                        borderColor: AppColors.borderColor,
                        enabledBorderColor: AppColors.borderColor,
                        hintColor: AppColors.borderColor,
                        textColor: AppColors.greyColor,
                        // items: ["5", "4", "3", "2", "1"],
                        type: ReactiveFields.TEXT,
                        controllerName: 'info.en',
                        textDirection: TextDirection.ltr,
                        label: 'Info',
                      ),
                    ),
                    ReactiveValueListenableBuilder<String>(
                      formControlName: 'type',
                      builder: (context, control, child) {
                        return control.value == 'home'
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ReactiveField(
                                  context: context,
                                  borderColor: AppColors.borderColor,
                                  enabledBorderColor: AppColors.borderColor,
                                  hintColor: AppColors.borderColor,
                                  textColor: AppColors.greyColor,
                                  type: ReactiveFields.TEXT,
                                  keyboardType: TextInputType.number,
                                  controllerName: 'price',
                                  label: locale.get('Price'),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ReactiveField(
                          context: context,
                          borderColor: AppColors.borderColor,
                          enabledBorderColor: AppColors.borderColor,
                          hintColor: AppColors.borderColor,
                          textColor: AppColors.greyColor,
                          // items: ["5", "4", "3", "2", "1"],
                          type: ReactiveFields.TEXT,
                          controllerName: 'description.ar',
                          textDirection: TextDirection.rtl,
                          maxLines: 2,
                          label: 'الوصف'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ReactiveField(
                          context: context,
                          borderColor: AppColors.borderColor,
                          enabledBorderColor: AppColors.borderColor,
                          hintColor: AppColors.borderColor,
                          textColor: AppColors.greyColor,
                          // items: ["5", "4", "3", "2", "1"],
                          type: ReactiveFields.TEXT,
                          controllerName: 'description.en',
                          textDirection: TextDirection.rtl,
                          maxLines: 2,
                          label: 'Description'),
                    ),
                    ReactiveValueListenableBuilder<String>(
                      formControlName: 'type',
                      builder: (context, control, child) {
                        return control.value == 'tutorial'
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: MultiSelectDialogField(
                                        items: days
                                            .map((e) => MultiSelectItem(
                                                e, locale.get(e)))
                                            .toList(),
                                        listType: MultiSelectListType.CHIP,
                                        onConfirm: (values) {
                                          model.selectedSteps
                                              .updateValue(values);
                                        },
                                        onSelectionChanged: (values) {
                                          model.selectedSteps
                                              .updateValue(values);
                                        },
                                        cancelText: Text(locale.get('Cancel')),
                                        confirmText:
                                            Text(locale.get('Confirm')),
                                        title: Text(locale.get('Select Days')),
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        buttonText:
                                            Text(locale.get('Select Days')),
                                        buttonIcon: Icon(Icons.arrow_drop_down),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            border: Border.all(
                                                color: Colors.grey,
                                                style: BorderStyle.solid,
                                                width: 0.5)),
                                        selectedItemsTextStyle:
                                            TextStyle(color: Colors.white),
                                        initialValue: model.selectedSteps.value,
                                        chipDisplay: MultiSelectChipDisplay(
                                          items: model.selectedSteps.value
                                              .map((e) => MultiSelectItem(e, e))
                                              .toList(),
                                          alignment: Alignment.center,
                                          scroll: true,
                                          textStyle:
                                              TextStyle(color: Colors.black87),
                                          scrollBar: HorizontalScrollBar(
                                              isAlwaysShown: false),
                                        ),
                                        selectedColor: AppColors.primaryColor),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ReactiveDropdownField(
                                      items: hours
                                          .map((item) =>
                                              DropdownMenuItem<dynamic>(
                                                value: item,
                                                child: new Text(
                                                  item.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                              ))
                                          .toList(),
                                      style: TextStyle(color: Colors.black),
                                      icon: Icon(
                                        Icons.arrow_drop_down_rounded,
                                      ),
                                      decoration: InputDecoration(
                                          // labelStyle: TextStyle(color: Colors.blue),
                                          fillColor: ReactiveField().fillColor,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            borderSide: BorderSide(
                                              color:
                                                  ReactiveField().borderColor,
                                              width: 0.5,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            borderSide: BorderSide(
                                              color: AppColors.red,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            borderSide: BorderSide(
                                              color: AppColors.red,
                                              width: 1.0,
                                            ),
                                          ),
                                          labelStyle: TextStyle(
                                              color: ReactiveField().textColor),
                                          hintStyle: TextStyle(
                                              color: ReactiveField().hintColor),
                                          labelText: locale.get('Choose Hour')

                                          // fillColor: Colors.white,
                                          ),
                                      formControlName: 'hour',
                                      // style: TextStyle(color: textColor),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            locale.get('Start Date') +
                                (model.form.control("startDate").valid
                                    ? ':' +
                                        Intl.DateFormat('dd-MM-yyyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                model.form
                                                    .control("startDate")
                                                    .value))
                                    : ''),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SfCalendar(
                            view: CalendarView.month,
                            todayHighlightColor: Colors.white,
                            todayTextStyle: TextStyle(color: Colors.black),
                            cellBorderColor: AppColors.primaryColor,
                            showCurrentTimeIndicator: true,
                            showNavigationArrow: true,
                            appointmentTextStyle:
                                const TextStyle(color: Colors.black),
                            selectionDecoration: BoxDecoration(
                              color:
                                  AppColors.secondaryElement.withOpacity(0.4),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  color: AppColors.secondaryElement,
                                  style: BorderStyle.solid,
                                  width: 0.5),
                            ),
                            viewNavigationMode: ViewNavigationMode.snap,
                            initialSelectedDate:
                                model.form.control("startDate").valid
                                    ? DateTime.fromMillisecondsSinceEpoch(
                                        model.form.control("startDate").value)
                                    : null,
                            monthViewSettings:
                                const MonthViewSettings(showAgenda: false),
                            onTap: (CalendarTapDetails value) {
                              model.form.control("startDate").updateValue(
                                  value.date.millisecondsSinceEpoch);
                              model.setState();
                            },
                          ),
                        ],
                      ),
                    ),
                    ReactiveFormConsumer(
                      builder: (context, form, child) {
                        return NormalButton(
                            color: form.valid
                                ? AppColors.primaryColor
                                : Colors.blueGrey,
                            onPressed: () {
                              if (form.valid) {
                                if (course != null) {
                                  model.updateCourse();
                                } else {
                                  model.createCourse();
                                }
                              } else {
                                print('invalid');
                              }
                              // Logger().wtf(model.form.value);
                            },
                            child: Text(
                              locale.get('Save'),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ));
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  // dateTimePicker(context, model) {
  //   DatePicker.showDatePicker(context,
  //       showTitleActions: true,
  //       minTime: DateTime(1960, 3, 5),
  //       maxTime: DateTime.now(), onChanged: (date) {
  //     print('change $date');
  //   }, onConfirm: (date) {
  //     print('confirm $date');
  //     print(date.millisecondsSinceEpoch);
  //     model.form
  //         .control('birthDate')
  //         .updateValue(date.millisecondsSinceEpoch.toString());
  //     dateTime = date;
  //     model.setState();
  //   }, currentTime: DateTime.now(), locale: LocaleType.en);
  // }
}
