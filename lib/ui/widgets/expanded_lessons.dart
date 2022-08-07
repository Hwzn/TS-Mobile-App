import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/view-assignments.page.dart';

import '../../core/models/course.dart';
import '../pages/student/HomePage/courses_tab/course_page/course_page_view_model.dart';

class ExpandedLessons extends StatelessWidget {
  final Content content;
  final Course course;
  final CoursePageModel model;

  const ExpandedLessons({this.content, this.model, this.course});
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    bool isExpanded = true;

    return Center(
      child: Container(
        width: SizeConfig.widthMultiplier * 90,
        key: UniqueKey(),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10)),
        child: ExpansionTile(
          trailing: Icon(
            isExpanded ? Icons.remove : Icons.add,
            color: AppColors.primaryColor,
          ),
          key: UniqueKey(),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (value) {
            isExpanded = value;
          },
          backgroundColor: Colors.transparent,
          title: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Text(
              "${content.chapter}",
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: TextStyle(color: AppColors.red, fontSize: 20),
            ),
          ),
          children: [
            Container(
              key: UniqueKey(),
              margin: EdgeInsets.all(1),
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: content.lessons.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${content.lessons[index].name}",
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          if (content.lessons[index].isDone)
                            IconButton(
                              icon: Icon(Icons.done,
                                  size: 15, color: Colors.blueGrey),
                              onPressed: () {},
                            ),
                          if (((locator<AuthenticationService>().userLoged &&
                                  locator<AuthenticationService>()
                                          .user
                                          .userType ==
                                      'Teacher')) &&
                              !content.lessons[index].isDone)
                            "${content.lessons[index].type}" == "video"
                                ? IconButton(
                                    icon: Icon(Icons.play_circle_fill_outlined,
                                        size: 15,
                                        color: AppColors.primaryColor),
                                    onPressed: () {
                                      model.showAlertDialog(
                                          model, content.lessons[index]);
                                    },
                                  )
                                : Container(
                                    child: Row(
                                      children: locator<AuthenticationService>()
                                                  .userLoged &&
                                              locator<AuthenticationService>()
                                                      .user
                                                      .userType ==
                                                  'Teacher'
                                          ? [
                                              IconButton(
                                                icon: Icon(Icons.remove_red_eye,
                                                    size: 15,
                                                    color: Colors.blueGrey),
                                                tooltip: locale
                                                    .get('View Assignments'),
                                                onPressed: () async {
                                                  showModalBottomSheet(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10.0))),
                                                      isScrollControlled: true,
                                                      // enableDrag: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return new Container(
                                                          height: SizeConfig
                                                                  .heightMultiplier *
                                                              80,
                                                          color: Colors
                                                              .transparent, //could change this to Color(0xFF737373),
                                                          //so you don't have to change MaterialApp canvasColor
                                                          child: ViewAssignmentsPage(
                                                              model: model,
                                                              ctx: context,
                                                              exersices: content
                                                                  .lessons[
                                                                      index]
                                                                  .exersices),
                                                        );
                                                      });
                                                },
                                              ),
                                            ]
                                          : [
                                              IconButton(
                                                icon: Icon(
                                                    Icons.download_outlined,
                                                    size: 15,
                                                    color: Colors.blueGrey),
                                                tooltip: locale
                                                    .get('View Assignment'),
                                                onPressed: () async {
                                                  // String path = await ExtStorage
                                                  //     .getExternalStoragePublicDirectory(
                                                  //         ExtStorage
                                                  //             .DIRECTORY_DOWNLOADS);
                                                  final taskId =
                                                      await FlutterDownloader
                                                          .enqueue(
                                                    url: content.lessons[index]
                                                        .attachement.path,

                                                    savedDir: '/ts-academy',
                                                    showNotification:
                                                        true, // show download progress in status bar (for Android)
                                                    openFileFromNotification:
                                                        true, // click on notification to open downloaded file (for Android)
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.assignment,
                                                    size: 15,
                                                    color: Colors.red),
                                                tooltip: locale
                                                    .get('Submit Assignment'),
                                                onPressed: () {
                                                  model.chooseFile(
                                                      content
                                                          .lessons[index].oId,
                                                      course.sId);
                                                },
                                              )
                                            ],
                                    ),
                                  ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
