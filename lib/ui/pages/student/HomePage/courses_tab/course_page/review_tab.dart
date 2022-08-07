import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view_model.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/review_course_card.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';

class CourseReviewsTab extends StatelessWidget {
  const CourseReviewsTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Consumer<CoursePageModel>(builder: (context, model, _) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.locale.get("Global Rate"),
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  model.course.rate.toStringAsFixed(2),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 24, color: AppColors.red),
                ),
                RatingBar.builder(
                  initialRating: model.course?.rate?.toDouble(),
                  minRating: 4,
                  maxRating: 4,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 25,
                  // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_rounded,
                    color: AppColors.rateColorDark,
                  ),
                  unratedColor: Colors.grey[200],
                  onRatingUpdate: (rating) {},
                ),
                Text(
                  "${model.locale.get("With")} ${model.course.reviews.length} ${model.locale.get("Review")}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(height: 1, color: Colors.grey[100]),
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: model.course.reviews.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ReviewCourseCardHorizontal(
                review: model.course.reviews[index],
              ),
              addAutomaticKeepAlives: true,
            ),
          ],
        ),
      );
    });
  }
}
