import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/MainHome/main_home_view.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/main_ui_teacher.page.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebbView extends StatefulWidget {
  final url;

  const PaymentWebbView({Key key, this.url}) : super(key: key);
  @override
  PaymentWebbViewState createState() => PaymentWebbViewState();
}

class PaymentWebbViewState extends State<PaymentWebbView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    // final flutterWebviewPlugin = FlutterWebviewPlugin();
    // flutterWebviewPlugin.onUrlChanged.listen((String url) {
    //   if (url.contains('https://tsacademy.info/')) {
    //     AuthenticationService auth = locator<AuthenticationService>();
    //     // await auth.signOut;
    //     locator<AuthenticationService>().loadUser;
    //     if (auth.user.userType == "Student") {
    //       UI.pushReplaceAll(context, MainUI());
    //     } else if (auth.user.userType == "Teacher") {
    //       final locale = AppLocalizations.of(context);
    //       if (auth.user.teacherApproved == true)
    //         UI.pushReplaceAll(context, MainUITeacher());
    //       else {
    //         UI.pushReplaceAll(context, MainUITeacher());
    //         UI.showSnackBarMessage(
    //             context: context,
    //             message: locale.get('Please wait until approve your account'));
    //       }
    //     } else {
    //       UI.pushReplaceAll(
    //           context,
    //           MainUI(
    //             isParent: true,
    //           ));
    //     }
    //   }
    // });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          locale.get("Payment"),
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Theme(
          data: Theme.of(context),
          child:
              //  WebviewScaffold(
              //   resizeToAvoidBottomInset: true,
              //   url: widget.url,
              //   scrollBar: false,
              //   appBar: AppBar(
              //     centerTitle: true,
              //     title: Text(
              //       locale.get("Payment"),
              //       style:
              //           Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
              //     ),
              //     leading: InkWell(
              //         onTap: () {
              //           Navigator.pop(context);
              //         },
              //         child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
              //     backgroundColor: Colors.transparent,
              //     elevation: 0.0,
              //   ),
              // ),
              WebView(
            debuggingEnabled: true,
            navigationDelegate: (navigation) {
              if (navigation.url.startsWith('https://tsacademy.info/')) {
                AuthenticationService auth = locator<AuthenticationService>();
                locator<AuthenticationService>().loadUser;
                if (auth.user.userType == "Student") {
                  UI.pushReplaceAll(context, MainUI());
                } else if (auth.user.userType == "Teacher") {
                  final locale = AppLocalizations.of(context);
                  if (auth.user.teacherApproved == true) {
                    UI.pushReplaceAll(context, const MainUITeacher());
                  } else {
                    UI.pushReplaceAll(context, const MainUITeacher());
                    UI.showSnackBarMessage(
                        context: context,
                        message: locale
                            .get('Please wait until approve your account'));
                  }
                } else {
                  UI.pushReplaceAll(
                      context,
                      MainUI(
                        isParent: true,
                      ));
                }
                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            },
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            allowsInlineMediaPlayback: true,
          )),
    );
  }
}
