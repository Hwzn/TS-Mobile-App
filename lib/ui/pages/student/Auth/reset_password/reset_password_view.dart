import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/button_loading.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';
import 'reset_password_view_model.dart';

class StudentResetPasswordPage extends StatelessWidget {
  bool isEng = true;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<StudentResetPasswordPageModel>(
      create: (context) => StudentResetPasswordPageModel(),
      child: Consumer<StudentResetPasswordPageModel>(
          builder: (context, model, __) {
        return Scaffold(
            body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButton(),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 5,
                ),
                ReactiveForm(
                    formGroup: model.form,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            locale.get("Reset Password") ?? "Reset Password",
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
                                    "Enter your phone number and we will send you a link to reset your password") ??
                                "Enter your phone number and we will send you a link to reset your password",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 15),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 3,
                          ),
                          ReactiveField(
                            borderColor: Colors.black,
                            enabledBorderColor: Colors.black,
                            hintColor: Colors.black,
                            keyboardType: TextInputType.phone,
                            type: ReactiveFields.TEXT,
                            controllerName: 'phoneNumber',
                            label: locale.get('Phone number') ?? 'Phone number',
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 3,
                          ),
                          model.busy
                              ? ButtonLoading()
                              : NormalButton(
                                  onPressed: () {
                                    model.form.markAllAsTouched();
                                    if (model.form.valid) {
                                      model.resetPassword(context);
                                    }
                                    // UI.push(context, VerifyAccountPage());
                                  },
                                  text: "Reset Password",
                                  color: AppColors.primaryColor,
                                  raduis: 1,
                                  bold: false,
                                ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ));
      }),
    );
  }
}
