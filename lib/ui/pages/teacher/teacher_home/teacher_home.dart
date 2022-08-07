import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/review_course_card.dart';
import 'package:ts_academy/ui/pages/teacher/add_courses/add_course/add_course_data.dart';
import 'package:ts_academy/ui/pages/teacher/teacher_home/teacher_home_view_model.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/widgets/cached_image.dart';
import 'package:ts_academy/ui/widgets/loading.dart';

import '../../../styles/size_config.dart';

enum TeacherStatState { NONE, Increase, decrease }

class TeacherHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<TeacherHomePageModel>(
        create: (context) => TeacherHomePageModel(),
        child: Consumer<TeacherHomePageModel>(builder: (context, model, __) {
          return SafeArea(
            child: Scaffold(
              body: model.teacherHomeModel == null
                  ? const Center(child: Loading())
                  : ListView(
                      children: [
                        greeting(locale, context),
                        createCourseCard(context, locale),
                        if (model.teacherHomeModel.todayCourses.isNotEmpty) ...[
                          titleWidget(locale.get('Today Courses')),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  todayCoursesWidget(
                                      model
                                          .teacherHomeModel.todayCourses[index],
                                      context),
                              itemCount:
                                  model.teacherHomeModel.todayCourses.length,
                            ),
                          ),
                        ],
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2,
                        ),
                        titleWidget(locale.get('Your Statistics')),
                        Center(
                          child: RatingBar.builder(
                            initialRating:
                                model.teacherHomeModel.rate.toDouble(),
                            minRating: 4,
                            maxRating: 5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 50,
                            ignoreGestures: true,
                            // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_rounded,
                              color: AppColors.primaryColor,
                            ),
                            unratedColor: Colors.grey[200],
                            onRatingUpdate: (double value) {},
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              statisticsInfo(
                                  text: locale.get('Course'),
                                  number: model.teacherHomeModel.noOfCourses
                                      .toString(),
                                  stat: TeacherStatState.NONE),
                              statisticsInfo(
                                  text: locale.get('Student'),
                                  number: model.teacherHomeModel.noOfStudents
                                      .toString(),
                                  stat: TeacherStatState.Increase),
                              statisticsInfo(
                                  text: locale.get('Rate'),
                                  number: model.teacherHomeModel.rate
                                      .toInt()
                                      .toString(),
                                  stat: TeacherStatState.decrease),
                            ],
                          ),
                        ),
                        titleWidget(locale.get('Latest Feedback')),
                        Container(
                          height: SizeConfig.heightMultiplier * 14,
                          margin: const EdgeInsets.only(left: 20),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => SizedBox(
                                width: SizeConfig.widthMultiplier * 70,
                                child: ReviewCourseCardHorizontal(
                                  review: model
                                      .teacherHomeModel.latestFeedback[index],
                                  isFromHome: true,
                                )),
                            itemCount:
                                model.teacherHomeModel.latestFeedback.length,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        }));
  }
}

Widget statisticsInfo({String text, String number, TeacherStatState stat}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            number.toString(),
            style: TextStyle(
                color: Color(0xffCC1C60),
                fontSize: SizeConfig.textMultiplier * 2.5,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: SizeConfig.textMultiplier * 2.2,
              fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

Widget todayCoursesWidget(Course course, context) {
  final locale = AppLocalizations.of(context);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Container(
            width: 80,
            height: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: course.status == 'pending'
                    ? AppColors.red
                    : AppColors.primaryColor),
            child: CachedImage(
              width: 80,
              radius: 8,
              height: 90,
              imageUrl: '$BaseFileUrl${course.cover?.localized(context) ?? ''}',
              boxFit: BoxFit.cover,
            )),
        Container(
          width: SizeConfig.widthMultiplier * 40,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  pushNewScreen(context,
                      screen:
                          CoursePage(courseId: course.sId, isMyCourse: true),
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      withNavBar: false);
                },
                child: Text(course.name?.localized(context) ?? '',
                    style: TextStyle(fontSize: SizeConfig.textMultiplier * 2)),
              ),
              Text(
                  "${course.grade.name.localized(context)}-${course.stage.name.localized(context)}",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: SizeConfig.textMultiplier * 1.8)),
              Text(
                locale.get('Send Notification'),
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: SizeConfig.textMultiplier * 2),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget titleWidget(String title) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Text(
        title,
        style: TextStyle(
            fontSize: SizeConfig.textMultiplier * 2.4,
            fontWeight: FontWeight.w700),
      ));
}

Widget createCourseCard(BuildContext context, locale) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: SizeConfig.heightMultiplier * 18,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.heightMultiplier * 1)),
          gradient: LinearGradient(
              colors: locale.locale.languageCode == 'en'
                  ? [Colors.red, Colors.blue]
                  : [Colors.blue, Colors.red])),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.get('Jump into course creation'),
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 3.2,
                  color: Colors.white),
            ),
            Align(
              alignment: locale.locale.languageCode == 'en'
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCourseData(),
                        ));
                  },
                  child: Text(locale.get('Create your Course'))),
            )
          ],
        ),
      ),
    ),
  );
}

Widget greeting(locale, context) {
  final locale = AppLocalizations.of(context);
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${locale.get('Welcome')} ${locator<AuthenticationService>().user.name}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              DateTime.now().toString().substring(0, 11),
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
        CircleAvatar(
          radius: 35,
          backgroundColor: AppColors.secondaryElement,
          backgroundImage: NetworkImage(BaseFileUrl +
              (locator<AuthenticationService>().user.avatar ?? '')),
          onBackgroundImageError: (exception, stackTrace) =>
              Image.asset('assets/images/appicon.png'),
        )
      ],
    ),
  );
}
