import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/home_tab/course_widget.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/chat/chat_page.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/chat/chat_service.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/loading.dart';

import 'instructor_profile_view_model.dart';

class InstructorProfilePage extends StatelessWidget {
  String teacherId;
  InstructorProfilePage({this.teacherId});
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<InstructorProfilePageModel>(
      create: (context) => InstructorProfilePageModel(teacherId: teacherId),
      child:
          Consumer<InstructorProfilePageModel>(builder: (context, model, __) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            title: Text(
              "",
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          extendBodyBehindAppBar: true,
          body: model.busy
              ? Center(child: Loading())
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: CachedNetworkImage(
                                    imageUrl:
                                        "${model.api.imagePath}${model.teacher.avatar}",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          // width: SizeConfig.widthMultiplier * 20,
                                          // height: SizeConfig.heightMultiplier * 10,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(60),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                            width:
                                                SizeConfig.widthMultiplier * 10,
                                            height:
                                                SizeConfig.heightMultiplier * 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Image.asset(
                                                'assets/images/appicon.png'))),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      model.teacher.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // if (locator<AuthenticationService>()
                                  //     .userLoged)
                                  //   InkWell(
                                  //       onTap: () {
                                  //         ChatService.createChat(
                                  //             name2: locator<
                                  //                     AuthenticationService>()
                                  //                 .user
                                  //                 .name,
                                  //             userId2: locator<
                                  //                     AuthenticationService>()
                                  //                 .user
                                  //                 .sId,
                                  //             pic2: locator<
                                  //                     AuthenticationService>()
                                  //                 .user
                                  //                 .avatar,
                                  //             userId1: model.teacher.userId,
                                  //             name1: model.teacher.name,
                                  //             pic1: model.teacher.avatar);
                                  //         UI.push(
                                  //             context,
                                  //             ChatPage(
                                  //               userId: model.teacher.userId,
                                  //               userName: model.teacher.name,
                                  //               userAvatar:
                                  //                   model.teacher.avatar,
                                  //             ));
                                  //       },
                                  //       child: Icon(Icons.chat))
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: SizeConfig.widthMultiplier * 70,
                              child: Text(
                                model.teacher.bio ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: SizeConfig.widthMultiplier * 25,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        model.teacher.noOfCourses.toString(),
                                        style: TextStyle(
                                            color: AppColors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        locale.get("Course"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: SizeConfig.widthMultiplier * 25,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        model.teacher.noOfStudents.toString(),
                                        style: TextStyle(
                                            color: AppColors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        locale.get('Student'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: SizeConfig.widthMultiplier * 25,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        model.teacher.rate
                                                ?.toStringAsFixed(1) ??
                                            "5",
                                        style: TextStyle(
                                            color: AppColors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        locale.get('Rate'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(color: Colors.blueGrey, height: .5),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              locale.get("Courses By") +
                                  " " +
                                  model.teacher.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.black, fontSize: 16),
                            ),
                          ),
                          coursesList(model.teacher.courses),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      }),
    );
  }

  Widget coursesList(List<Course> courses) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: courses
              .map<Widget>((course) => CourseCardHorizontal(course: course))
              .toList()),
    );
  }
}
