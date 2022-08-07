import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/Auth/verify_account/verfiy_account_view_model.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/button_loading.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VerifyAccountPage extends StatefulWidget {
  bool resetPasseord;
  VerifyAccountPage({this.resetPasseord = false});

  @override
  _VerifyAccountPageState createState() =>
      _VerifyAccountPageState(resetPasseord: resetPasseord);
}

class _VerifyAccountPageState extends State<VerifyAccountPage>
    with TickerProviderStateMixin {
  bool resetPasseord;
  _VerifyAccountPageState({this.resetPasseord = false});
  bool _obscureText = false;

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  int secondsRemaining = 30;
  bool enableResend = false;
  Timer timer;

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<VerifyAccountPageModel>(
      create: (context) => VerifyAccountPageModel(),
      child: Consumer<VerifyAccountPageModel>(builder: (context, model, __) {
        return Scaffold(
            body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButton(
                  onPressed: () {
                    UI.pushReplaceAll(context, StudentLoginPage());
                  },
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 5,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.get("Verify Account") ?? "Verify Account",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 20),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 3,
                        ),
                        Text(
                          locale.get(
                                  "Enter the code sent to your email / phone") ??
                              "Enter the code sent to your email / phone",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 15),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 4,
                        ),
                        _binCodeWidget(model, context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if (enableResend) {
                                  model.resendCode(context);
                                  secondsRemaining = 30;

                                  enableResend = false;
                                }
                              },
                              child: Text(
                                locale.get('Resend Code'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: AppColors.primaryColor),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        model.busy
                            ? ButtonLoading()
                            : NormalButton(
                                onPressed: () {
                                  if (_pinPutController.text.isEmpty) {
                                    UI.toast("please enter code");
                                  } else {
                                    // locator<AuthenticationService>().signOut;
                                    model.activateUser(context,
                                        _pinPutController.text, resetPasseord);
                                  }
                                },
                                text: locale.get('Verify Account'),
                                color: _pinPutController.text.isEmpty
                                    ? AppColors.red
                                    : AppColors.primaryColor,
                                raduis: 1,
                                bold: false,
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      UI.pushReplaceAll(context, StudentLoginPage());
                    },
                    child: Text(
                      locale.get('Back to login'),
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      }),
    );
  }

  Container _binCodeWidget(model, context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PinPut(
          fieldsCount: 5,
          onSubmit: (String pin) =>
              model.activateUser(context, pin, resetPasseord),
          focusNode: _pinPutFocusNode,
          controller: _pinPutController,
          submittedFieldDecoration: _pinPutDecoration.copyWith(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.black.withOpacity(.5),
            ),
          ),
          selectedFieldDecoration: _pinPutDecoration,
          followingFieldDecoration: _pinPutDecoration.copyWith(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.black.withOpacity(.5),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(15.0),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value * 60);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 20,
        color: Colors.grey,
      ),
    );
  }
}
