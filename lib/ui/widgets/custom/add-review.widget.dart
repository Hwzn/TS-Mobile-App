import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view_model.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/text_fields/custom_text_field.dart';

import '../main_button.dart';

class AddReviewWidget extends StatelessWidget {
  final CoursePageModel model;

  const AddReviewWidget(this.model);
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    TextEditingController commentController = new TextEditingController();
    final reviewBody = {'stars': 0, 'comment': ""};
    return Container(
      alignment: Alignment.topCenter,
      height: SizeConfig.heightMultiplier * 40,
      width: SizeConfig.widthMultiplier * 90,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Add Review ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 50,
                glow: true,

                // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star_rounded,
                  color: AppColors.primaryColor,
                ),
                unratedColor: Colors.grey[200],
                onRatingUpdate: (rating) {
                  reviewBody['stars'] = rating;
                },
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: commentController,
                hint: locale.get('Write Review'),
                label: locale.get('Write Review'),
                lines: 3,
                // color: Colors.grey[100],
              ),
              SizedBox(
                height: 20,
              ),
              MainButton(
                text: locale.get('Submit'),
                onTap: () {
                  reviewBody['comment'] = commentController.text;
                  model.writeReview(reviewBody);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
