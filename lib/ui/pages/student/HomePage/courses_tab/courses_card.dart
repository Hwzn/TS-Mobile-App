import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/cached_image.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class CoursehorizontalCard extends StatelessWidget {
  final Course course;
  const CoursehorizontalCard({Key key, this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          pushNewScreen(context,
              screen: CoursePage(
                courseId: course.sId,
                isMyCourse: true,
              ),
              pageTransitionAnimation: PageTransitionAnimation.slideUp,
              withNavBar: false);
        },
        child: SizedBox(
          width: SizeConfig.widthMultiplier * 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: SizeConfig.widthMultiplier * 30,
                height: SizeConfig.heightMultiplier * 14,
                child: CachedNetworkImage(
                  // height: 110,
                  fit: BoxFit.cover,
                  // width: SizeConfig.widthMultiplier * 30,
                  imageUrl:
                      BaseFileUrl + (course.cover.localized(context) ?? ''),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: SizeConfig.heightMultiplier * 14,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        course.name?.localized(context) ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: AppColors.primaryColorDark),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        course.grade.name.localized(context) +
                            ' - ' +
                            course.grade.stage.name.localized(context),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        course.info?.localized(context) ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '${locale.get("Starts")}: '),
                            TextSpan(
                              text: DateFormat("EEEE d/M/y").format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      course.startDate)),
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
