import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/teacher/add_courses/add_course/add_course_data.dart';
import 'package:ts_academy/ui/pages/teacher/teacher_courses_tab/teacher_courses_view_model.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:ts_academy/ui/routes/ui.dart';

import 'teacher_courses_card.dart';

class TeacherCoursesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<TeacherCoursesPageModel>(
        create: (context) => TeacherCoursesPageModel(),
        child: Consumer<TeacherCoursesPageModel>(builder: (context, model, __) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  pushNewScreen(context,
                      screen: AddCourseData(),
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      withNavBar: false);
                },
              ),
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  locale.get('My Courses'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 20),
                ),
                actions: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: SvgPicture.asset(
                  //     "assets/images/search.svg",
                  //     color: Colors.black,
                  //   ),
                  // ),
                  // IconButton(
                  //   padding: const EdgeInsets.all(8.0),
                  //   icon: SvgPicture.asset(
                  //     "assets/images/Cart.svg",
                  //     color: Colors.black,
                  //   ),
                  //   onPressed: () {
                  //     UI.push(context, CartPage());
                  //   },
                  // ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              extendBodyBehindAppBar: true,
              body: SafeArea(
                child: model.busy ? Loading() : coursesList(model),
              ));
        }));
  }

  Widget coursesList(TeacherCoursesPageModel model) {
    return ListView.builder(
        itemCount: model?.courses?.length ?? 0,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Column(
            children: [
              TeacherCoursehorizontalCard(
                index: index,
                model: model,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: Colors.grey,
                  height: 1,
                ),
              )
            ],
          );
        });
  }
}
