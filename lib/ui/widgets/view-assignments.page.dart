import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view_model.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:mime/mime.dart';

class ViewAssignmentsPage extends StatelessWidget {
  CoursePageModel model;
  BuildContext ctx;
  List<Exersices> exersices;
  ViewAssignmentsPage({this.model, this.ctx, this.exersices});
  @override
  Widget build(context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<CoursePageModel>.value(
        value: model,
        child: Consumer<CoursePageModel>(builder: (ctx, model, __) {
          return Container(
            // height: SizeConfig.heightMultiplier * 80,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      Exersices exersice = exersices[index];

                      return ListTile(
                        leading: CircleAvatar(
                            child: CachedNetworkImage(
                                imageUrl:
                                    BaseFileUrl + (exersice.user.avatar ?? ''),
                                errorWidget: (context, url, error) => Container(
                                    child: Image.asset(
                                        'assets/images/appicon.png')))),
                        title: Text(exersice.user.name,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => Container(
                                      height: SizeConfig.heightMultiplier * 80,
                                      width: SizeConfig.widthMultiplier * 80,
                                      child: CachedNetworkImage(
                                          imageUrl: exersice.link,
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  child: Image.asset(
                                                      'assets/images/appicon.png'))),
                                    ));
                          },
                        ),
                        // trailing: Size
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                          height: 3,
                          child: Container(color: AppColors.primaryColorDark));
                    },
                    itemCount: exersices.length),
              ),
            ),
          );
        }));
  }
}
