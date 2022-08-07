import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view_model.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/review_student/review_student_view.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';

class CourseStudentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoursePageModel>(builder: (context, model, _) {
      return Scaffold(
        body: Container(
            // child: ListView.builder(
            //   itemCount: 0,
            //   padding: EdgeInsets.zero,
            //   // physics: const NeverScrollableScrollPhysics(),
            //   // shrinkWrap: true,
            //   itemBuilder: (context, index) {
            //     final locale = AppLocalizations.of(context);
            //     User student = model.course.students[index];
            //     return ListTile(
            //       title: Text(student.name),
            //       subtitle: Text(student.stage.name.localized(context) +
            //           ' - ' +
            //           student.grade.name.localized(context)),
            //       trailing: TextButton(
            //         onPressed: () {
            //           UI.push(
            //               context,
            //               ReviewStudentPage(
            //                   student: student,
            //                   courseId: model.course.sId,
            //                   subject: model.course.subject));
            //         },
            //         child: Text(
            //           locale.get("Review Student"),
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             color: AppColors.primaryColor,
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // ),
            ),
      );
    });
  }
}
