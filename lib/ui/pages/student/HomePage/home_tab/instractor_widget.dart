import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ts_academy/core/models/filter_model.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/cached_image.dart';

import '../../../../routes/ui.dart';
import '../courses_tab/instructor_profile/instructor_profile_view.dart';

class InstractorCard extends StatelessWidget {
  final Instructor instructor;

  const InstractorCard({Key key, this.instructor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          pushNewScreen(context,
              screen: InstructorProfilePage(teacherId: instructor.userId),
              pageTransitionAnimation: PageTransitionAnimation.slideRight);
        },
        child: SizedBox(
          height: SizeConfig.heightMultiplier * 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedImage(
                imageUrl: BaseFileUrl + (instructor.avatar ?? ''),
                boxFit: BoxFit.cover,
                width: SizeConfig.widthMultiplier * 40,
                height: SizeConfig.widthMultiplier * 40,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                instructor.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingBar.builder(
                    initialRating: instructor.rate?.toDouble() ?? 5.0,
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
                  Text(
                    "(${instructor.noOfReviews})",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
