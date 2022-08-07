import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view_model.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/instructor_profile/instructor_profile_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/home_tab/course_widget.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

import 'package:flutter_placeholder_textlines/placeholder_lines.dart';

class CourseInfoTab extends StatelessWidget {
  final dataKey = GlobalKey();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Consumer<CoursePageModel>(builder: (context, model, _) {
      return model.busy
          ? const PlaceholderLines(
              count: 10,
              align: TextAlign.center,
            )
          : Scaffold(
              body: locator<AuthenticationService>().userLoged &&
                      locator<AuthenticationService>().user?.userType ==
                          "Teacher"
                  ? teacherBody(context, model, locale)
                  : studentBody(context, model, locale));
    });
  }

  Widget coursesList(CoursePageModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: model.course.related
              .map<Widget>((course) => CourseCardHorizontal(course: course))
              .toList()),
    );
  }

  Widget studentBody(context, CoursePageModel model, locale) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 8, left: 8),
      child: SingleChildScrollView(
        controller: _controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.get('Info') + ":",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(model.course.info.localized(context),
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (model.course.excercices.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15),
                        child: Column(
                          children: [
                            Text(
                              "${model.course.excercices.length}",
                              style: const TextStyle(
                                  color: AppColors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              locale.get('Exercise'),
                            )
                          ],
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        children: [
                          Text(
                            '${model.course.enrolled}',
                            style: const TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(locale.get('Enrolled'))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              locale.get('Description'),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(model.course.description?.localized(context) ?? '',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            Row(
              children: [
                Text(locale.get('Starts at:'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      DateFormat("dd/MM/yyyy").format(
                          DateTime.fromMillisecondsSinceEpoch(
                              model.course.startDate)),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 14, color: AppColors.red)),
                )
              ],
            ),
            if (model.course?.type == 'tutorial') ...[
              Row(
                children: [
                  Text(
                    locale.get('Days:'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  ...model.course.days
                      .map((day) => Text(locale.get(day) + " ",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)))
                      .toList(),
                  const SizedBox(width: 10),
                  Text(locale.get('At')),
                  const SizedBox(width: 10),
                  Text(model.course.hour.toString(),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ],
            Text(
              locale.get('Created By'),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  pushNewScreen(context,
                      screen: InstructorProfilePage(
                        teacherId: model.course.teacher.sId,
                      ),
                      pageTransitionAnimation: PageTransitionAnimation.sizeUp,
                      withNavBar: false);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                        imageUrl:
                            BaseFileUrl + (model.course.teacher.avatar ?? ''),
                        imageBuilder: (context, imageProvider) => Container(
                              width: SizeConfig.widthMultiplier * 20,
                              height: SizeConfig.heightMultiplier * 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        // placeholder: (context, url) =>
                        //     CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Container(
                            width: SizeConfig.widthMultiplier * 10,
                            height: SizeConfig.heightMultiplier * 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset('assets/images/appicon.png'))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.course.teacher.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            // "${teacher.sId}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating:
                                    model.course.teacher?.cRating?.toDouble() ??
                                        5.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.rateColorDark,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                              const SizedBox(width: 3),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (model.course.related.isNotEmpty) ...[
              Text(
                locale.get("Related Courses"),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: coursesList(model),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget teacherBody(context, model, locale) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 8, left: 8),
      child: SingleChildScrollView(
        controller: _controller,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.course.info?.localized(context) ?? '',
                  style: TextStyle(fontSize: 14, wordSpacing: 5)),
              const SizedBox(height: 20),
              Text(
                locale.get('Description') + ":",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(model.course.description?.localized(context) ?? '',
                  style: Theme.of(context).textTheme.headline6),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(locale.get('Starts at:'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Text(
                      DateFormat("dd/MM/yyyy").format(
                          DateTime.fromMillisecondsSinceEpoch(
                              model.course.startDate)),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 14, color: AppColors.red))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    locale.get('Days:'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  ...model.course.days
                      .map((day) => Text(locale.get(day) + " ",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)))
                      .toList(),
                  const SizedBox(width: 10),
                  Text(locale.get('At')),
                  const SizedBox(width: 10),
                  Text(model.course.hour.toString(),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                locale.get("Curriculum") + ":",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // ...model.course.content.map((e) {
              //   return ListTile(
              //       leading: SvgPicture.asset('assets/images/check-done.svg'),
              //       title: Text(e.chapter),
              //       subtitle: Text(
              //         locale.get('Lessons') +
              //             ": " +
              //             e.lessons.length.toString(),
              //         style: TextStyle(color: Colors.grey),
              //       ));
              // }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
