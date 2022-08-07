import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view.dart';
import 'package:ts_academy/ui/pages/teacher/add_courses/add_course/add_course_data.dart';
import 'package:ts_academy/ui/pages/teacher/teacher_courses_tab/teacher_courses_view_model.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/cached_image.dart';
import 'package:ts_academy/ui/widgets/loading.dart';

// ignore: must_be_immutable
class TeacherCoursehorizontalCard extends StatelessWidget {
  int index;
  TeacherCoursesPageModel model;
  BuildContext context;
  TeacherCoursehorizontalCard({Key key, this.index, this.model, this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    bool moreMenu = false;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          pushNewScreen(context,
              screen: CoursePage(
                  courseId: model.courses[index].sId, isMyCourse: true),
              pageTransitionAnimation: PageTransitionAnimation.slideUp,
              withNavBar: false);
        },
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedImage(
                        imageUrl:
                            "${model.api.imagePath}${model.courses[index].cover?.localized(context)}",
                        boxFit: BoxFit.cover,
                        width: 60,
                        height: 60,
                        radius: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.courses[index].name.localized(context),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                          ),
                          Text(
                            model.courses[index].subject?.name
                                    ?.localized(context) ??
                                '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${model.courses[index].grade.stage.name.localized(context)} - ${model.courses[index].grade.name.localized(context)}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // Text.rich(
                          //   TextSpan(
                          //     children: [
                          //       TextSpan(
                          //           text: locale.get("Next Lesson:") + " "),
                          //       TextSpan(
                          //         text: getNextLesson(
                          //             locale, model.courses[index]),
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.normal,
                          //             color: AppColors.red),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // LinearPercentIndicator(
                          //   width: SizeConfig.widthMultiplier * 40,
                          //   animation: true,
                          //   animationDuration: 1000,
                          //   lineHeight: 10.0,
                          //   leading: new Text("%"),
                          //   percent: 50 / 100,
                          //   linearStrokeCap: LinearStrokeCap.roundAll,
                          //   progressColor: AppColors.indecatorColor,
                          //   backgroundColor: Colors.grey[300],
                          // ),
                        ],
                      ),
                      PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(locale.get('Edit')),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(locale.get('Delete')),
                            )
                          ];
                        },
                        onSelected: (String value) => actionPopUpItemSelected(
                            value, context, model.courses[index], model),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getNextLesson(locale, Course course) {
    //   if (course.startDate <= DateTime.now().millisecondsSinceEpoch &&
    //       course.progress < 100) {
    //     for (DateTime indexDay = DateTime.now();
    //         indexDay.isBefore(DateTime.now());
    //         indexDay = indexDay.add(Duration(days: 1))) {
    //       if (course.days != null &&
    //           course.days.firstWhere(
    //                   (element) => element == DateFormat('EEEE').format(indexDay),
    //                   orElse: () => null) !=
    //               null) {
    //         if (DateFormat('EEEE').format(indexDay) ==
    //                 DateFormat('EEEE').format(DateTime.now()) &&
    //             course.hour < DateTime.now().hour) continue;
    //         return DateFormat('EEEE').format(indexDay) + " :${course.hour}";
    //       }
    //       print(indexDay.toString());
    //     }
    //     return locale.get('hour') + "-" + course.hour.toString();
    //   } else if (course.progress >= 100) {
    //     return '';
    //   } else {
    //     return DateFormat('d/M/y')
    //         .format(DateTime.fromMillisecondsSinceEpoch(course.startDate));
    //   }
    // }
  }

  void showAlertDialog(
      BuildContext context, Course course, TeacherCoursesPageModel model) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                "Delete Course",
                style: TextStyle(color: Color(0xffE41616)),
              ),
              content: Text("Delete ${course.name.localized(context)} Course"),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () async {
                      // Logger().w("asdasdasdasd");
                      model.deleteTeacherCourse(course.sId, context);
                      Navigator.pop(context);
                    },
                    child: Text("Confirm")),
              ],
            ));
  }

  void actionPopUpItemSelected(String value, context, Course course, model) {
    String message;
    if (value == 'edit') {
      pushNewScreen(context,
          screen: AddCourseData(
            course: course,
          ),
          pageTransitionAnimation: PageTransitionAnimation.slideUp,
          withNavBar: false);
    } else if (value == 'delete') {
      showAlertDialog(context, course, model);
    } else {
      message = 'Not implemented';
    }
    print(message);
  }
}
