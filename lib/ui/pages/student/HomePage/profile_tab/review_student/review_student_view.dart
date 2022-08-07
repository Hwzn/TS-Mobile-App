import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ts_academy/core/models/subject.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/statistics/statistics_viewmodel.dart';
import 'package:ts_academy/ui/pages/teacher/teacher_home/teacher_home.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/main_button.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';
import 'review_student_viewmodel.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReviewStudentPage extends StatelessWidget {
  final User student;
  final String courseId;
  final Subject subject;
  const ReviewStudentPage({this.student, this.courseId, this.subject});
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<ReviewStudentPageModel>(
      create: (context) =>
          ReviewStudentPageModel(context, locale, student, courseId, subject),
      child: Consumer<ReviewStudentPageModel>(
        builder: (context, model, __) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                locale.get("Review Student"),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 20),
              ),
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.black)),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: model.busy
                ? Center(child: CircularProgressIndicator())
                : Container(
                    padding: const EdgeInsets.all(10),
                    child: ReactiveForm(
                      formGroup: model.form,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              student.stage.name.localized(context) +
                                  " - " +
                                  student.grade.name.localized(context),
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier * 5),
                            Container(
                              width: double.infinity,
                              height: SizeConfig.heightMultiplier * 30,
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                series: <CartesianSeries>[
                                  ColumnSeries<ChartData, String>(
                                    dataSource: model.chartDataList,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    color: Color(0xFFCC1C60),
                                    width: 0.2,
                                    trackPadding: 20,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                    ),
                                  ),
                                  ColumnSeries<ChartData, String>(
                                    dataSource: model.chartDataList,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) =>
                                        data.y1,
                                    color: Color(0xFF2CD9C5),
                                    width: 0.2,
                                    trackPadding: 20,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier * 5),
                            Column(
                              children: [
                                buildStatisticsItem(
                                    context,
                                    model,
                                    locale.get("Attendees"),
                                    "attendance",
                                    Color(0xFFFF6C40),
                                    isBoolean: true),
                                buildStatisticsItem(
                                  context,
                                  model,
                                  locale.get("performance"),
                                  "performance",
                                  Color(0xFFFFE700),
                                ),
                                buildStatisticsItem(
                                  context,
                                  model,
                                  locale.get("Grades"),
                                  "grades",
                                  Color(0xFFCC1C60),
                                ),
                                buildStatisticsItem(
                                  context,
                                  model,
                                  locale.get("Understanding"),
                                  "understanding",
                                  Color(0xFF2CD9C5),
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier * 5),
                            ReactiveFormConsumer(
                              builder: (context, formGroup, child) {
                                return MainButton(
                                    height: 50,
                                    color: formGroup.valid
                                        ? AppColors.primaryColor
                                        : Colors.blueGrey,
                                    text: locale.get("Save Student Review"),
                                    onTap: formGroup.valid
                                        ? () async {
                                            await model.addReviewStudent();
                                          }
                                        : () {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget buildStatisticsItem(BuildContext context, ReviewStudentPageModel model,
      String title, String control, Color color,
      {bool isBoolean = false}) {
    final locale = AppLocalizations.of(context);
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(width: 10),
                Text("$title"),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              width: SizeConfig.widthMultiplier * 50,
              child: Expanded(
                child: !isBoolean
                    ? ReactiveField(
                        borderColor: Colors.black,
                        enabledBorderColor: AppColors.borderColor,
                        hintColor: Colors.black,
                        type: ReactiveFields.TEXT,
                        controllerName: '$control',
                        keyboardType: TextInputType.number,
                        hint: "%100",
                        validationMesseges: {
                          'min': locale.get('Minimum Value is 0'),
                          'max': locale.get('Maximum Value is 100'),
                          'required': title + " " + locale.get('is required'),
                        },
                      )
                    : CheckboxListTile(
                        autofocus: false,
                        contentPadding: EdgeInsets.all(0),
                        activeColor: AppColors.primaryColor,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        selected: false,
                        value: model.form.control(control).value,
                        onChanged: (bool value) {
                          model.form.control(control).updateValue(value);
                          model.setState();
                          // _value = value;
                        }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
