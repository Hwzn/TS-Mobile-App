import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/models/notice.model.dart';
import 'package:ts_academy/core/models/student_model.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/notifications_tab/notifications_tab_view_model.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/chat/chat_page.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ts_academy/ui/widgets/main_button.dart';

class NotificationsTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    if (!locator<AuthenticationService>().userLoged) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            locale.get('Notifications'),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          height: SizeConfig.heightMultiplier * 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(locale.get('Please Login to View Your Notifications')),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: SizeConfig.widthMultiplier * 60,
                  child: MainButton(
                    text: locale.get('Login'),
                    onTap: () {
                      pushNewScreen(context,
                          screen: StudentLoginPage(), withNavBar: false);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return ChangeNotifierProvider<NotificationModel>(
        create: (context) => NotificationModel(context, locale),
        child: Consumer<NotificationModel>(
          builder: (context, model, _) {
            return model.busy
                ? Loading()
                : Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(
                        locale.get('Notifications'),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                    ),
                    body: Container(
                      child: allNotification(model),
                    ),
                  );
          },
        ));
  }

  Widget allNotification(model) {
    return ListView.separated(
        itemCount: model.notices.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return notificationWidget(context, model, index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 2);
        });
  }

  Widget notificationWidget(context, NotificationModel model, index) {
    Notice notice = model.notices[index];
    return InkWell(
      onTap: () {
        if (notice.entityType != null && notice.entityId != null) {
          if (notice.entityType == 'Course') {
            UI.push(context,
                CoursePage(courseId: notice.entityId, isMyCourse: true));
          }
          if (notice.entityType == 'Chat') {
            UI.push(
                context,
                ChatPage(
                  userId: notice.entityId,
                  userName: notice.title,
                ));
          }
        }
      },
      child: Container(
        // height: 57,
        color: notice.entityType != null && notice.entityId != null
            ? Colors.pink[50]
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notice.title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                notice.body,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 14, fontWeight: FontWeight.w200),
              ),
              Text(
                timeago.format(
                    DateTime.fromMillisecondsSinceEpoch(notice.valueDate),
                    locale: model.locale.locale.languageCode),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 14, color: AppColors.greyColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
