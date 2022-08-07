import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view_model.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/expanded_lessons.dart';

class CourseLessonsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Consumer<CoursePageModel>(builder: (context, model, _) {
      return Scaffold(
        body: SizedBox(
            // child: ListView.separated(
            //     itemCount: 0,
            //     padding: EdgeInsets.zero,
            //     // physics: const NeverScrollableScrollPhysics(),
            //     // shrinkWrap: true,
            //     separatorBuilder: (context, index) => Divider(),
            //     itemBuilder: (context, index) => ExpandedLessons(
            //         content: model.course.content[index],
            //         course: model.course,
            //         model: model)),
            ),
      );
    });
  }
}
