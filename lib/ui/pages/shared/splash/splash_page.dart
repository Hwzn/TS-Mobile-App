import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/core/services/notification/notification_service.dart';
import 'package:ts_academy/core/services/pricing.service.dart';
import 'package:ts_academy/ui/pages/shared/change_Language/change_language_view.dart';
import 'package:ts_academy/ui/pages/student/Auth/verify_account/verify_account_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/MainHome/main_home_view.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/main_ui_teacher.page.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2)).then((value) async {
        // await locator<PricingService>().getPricing();
        locator<NotificationService>().init();
        AuthenticationService auth = locator<AuthenticationService>();
        if (auth.userLoged) {
          // await auth.signOut;
          locator<AuthenticationService>().loadUser;
          // if (auth.user.isActive) {
          if (auth.user.userType == "Student") {
            pushNewScreen(
              context,
              screen: MainUI(),
              pageTransitionAnimation: PageTransitionAnimation.slideUp,
            );
          } else if (auth.user.userType == "Teacher") {
            final locale = AppLocalizations.of(context);
            if (auth.user.teacherApproved == true) {
              pushNewScreen(
                context,
                screen: const MainUITeacher(),
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
              );
            } else {
              pushNewScreen(
                context,
                screen: const MainUITeacher(),
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
              );

              UI.showSnackBarMessage(
                  context: context,
                  message:
                      locale.get('Please wait until approve your account'));
            }
          } else {
            UI.pushReplaceAll(
                context,
                MainUI(
                  isParent: true,
                ));
          }
          // } else {
          //   UI.pushReplaceAll(context, VerifyAccountPage());
          // }
        } else {
          pushNewScreen(context,
              screen: ChangeLanguagePage(),
              pageTransitionAnimation: PageTransitionAnimation.slideUp,
              withNavBar: false);
          // UI.pushReplaceAll(context, VerifyAccountPage());
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Center(
              child: Image.asset(
        "assets/images/Logo.png",
        width: SizeConfig.widthMultiplier * 20,
      ))),
    );
  }
}
