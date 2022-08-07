import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:ts_academy/core/models/review.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/styles/styles.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewCourseCardHorizontal extends StatelessWidget {
  final Review review;
  final bool isFromHome;

  const ReviewCourseCardHorizontal({this.review, this.isFromHome = false});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Container(
      child: Flexible(
        child: SizedBox(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.secondaryElement,
                  backgroundImage:
                      NetworkImage(BaseFileUrl + (review?.user?.avatar ?? '')),
                  onBackgroundImageError: (exception, stackTrace) =>
                      Image.asset('assets/images/appicon.png'),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(review.user?.name ?? "",
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    !isFromHome
                        ? RatingBar.builder(
                            initialRating: review.stars.toDouble(),
                            minRating: 5,
                            maxRating: 5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 15,
                            // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_rounded,
                              color: AppColors.rateColorDark,
                            ),
                            unratedColor: Colors.grey[200],
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          )
                        : const SizedBox()
                  ],
                ),
                trailing: !isFromHome
                    ? Text(
                        review.time != null
                            ? timeago.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    review.time),
                                locale: locale.locale.languageCode,
                                allowFromNow: false)
                            : '',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.grey, fontSize: 12),
                      )
                    : const SizedBox(),
                subtitle: !isFromHome
                    ? Text(review.comment,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.grey, fontSize: 12))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar.builder(
                              initialRating: review.stars.toDouble(),
                              minRating: 4,
                              maxRating: 4,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 15,
                              // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                    Icons.star_rounded,
                                    color: AppColors.rateColorDark,
                                  ),
                              unratedColor: Colors.grey[200],
                              onRatingUpdate: (rating) {
                                print(rating);
                              }),
                          Text(review.comment,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.grey, fontSize: 12))
                        ],
                      ),
              ),
              !isFromHome
                  ? Container(height: 1, color: Colors.grey[100])
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
