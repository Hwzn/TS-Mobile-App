import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/widgets/cached_image.dart';
import 'package:ts_academy/ui/widgets/loading.dart';

import '../../../../../core/models/course.dart';
import 'package:timeago/timeago.dart' as timeago;

class CourseCardHorizontal extends StatelessWidget {
  final bool topRated;
  final bool addedRecently;
  final Course course;
  const CourseCardHorizontal({
    this.topRated = false,
    this.addedRecently = false,
    this.course,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          pushNewScreen(context,
              screen: CoursePage(courseId: course.sId),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.slideRight);
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          width: SizeConfig.widthMultiplier * 55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: CachedImage(
                      imageUrl:
                          BaseFileUrl + (course.cover.localized(context) ?? ''),
                      boxFit: BoxFit.cover,
                      width: SizeConfig.widthMultiplier * 55,
                      height: SizeConfig.heightMultiplier * 20,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: locale.locale.languageCode == 'en' ? 10 : null,
                    right: locale.locale.languageCode == 'ar' ? 10 : null,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppColors.secondaryElement),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          locale.get(course.type).toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Text(
                course.name?.localized(context) ?? "",
                // "Flutter 2.2",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              Text(
                course.info?.localized(context) ?? "",
                // "fdsAA fsdf sd  sdf dsf ds f dsfsdf",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey),
              ),
              const SizedBox(height: 5),
              addedRecently
                  ? Text(
                      timeago.format(
                          DateTime.fromMillisecondsSinceEpoch(
                              course.createdAt ??
                                  DateTime.now().millisecondsSinceEpoch),
                          locale: locale.locale.languageCode),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.blueGrey),
                    )
                  : Row(
                      children: [
                        RatingBar.builder(
                          initialRating: (course.rate ?? 5).toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,

                          itemCount: 5,
                          itemSize: 20,
                          ignoreGestures: true,
                          // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star_rounded,
                            color: AppColors.rateColorDark,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        Text(
                          "(${course.reviews?.length ?? ""})",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
              const SizedBox(
                height: 5,
              ),
              Text(
                course.typedPrice,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.red),
              ),
              const SizedBox(
                height: 5,
              ),
              topRated
                  ? Container(
                      decoration: BoxDecoration(color: AppColors.secondry),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          locale.get("Top Rated"),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
