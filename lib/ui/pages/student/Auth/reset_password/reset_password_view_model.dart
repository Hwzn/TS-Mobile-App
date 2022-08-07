import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/ui/pages/student/Auth/verify_account/verify_account_view.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class StudentResetPasswordPageModel extends BaseNotifier {
  FormGroup form;

  StudentResetPasswordPageModel() {
    form = FormGroup({
      'phoneNumber': FormControl(
        validators: [
          Validators.required,
          // Validators.composeOR(
          //     [Validators.email, Validators.pattern(phoneRegex)])
        ],
      ),
    }, validators: []);
  }

  User user;
  void resetPassword(context) async {
    setBusy();
    var res = await api.resetPassword(context,
        username: form.control("phoneNumber").value);
    print(form.value);
    res.fold((error) {
      setError();
      ErrorDialog().notification(
        error.message.toString(),
        Colors.red,
      );
    }, (data) {
      user = User.fromJson(data);
      locator<AuthenticationService>().saveUser(user);
      pushNewScreen(context,
          screen: VerifyAccountPage(
            resetPasseord: true,
          ),
          pageTransitionAnimation: PageTransitionAnimation.slideUp,
          withNavBar: false);

      setIdle();
    });
  }
}
