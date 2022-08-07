import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/button_loading.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';


import 'change_password_view_model.dart';

class StudentChangePasswordPage extends StatelessWidget {
  bool isEng = true;
  bool _obscureText = false;
  bool _obscureText1 = false;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<StudentChangePasswordPageModel>(
      create: (context) => StudentChangePasswordPageModel(),
      child: Consumer<StudentChangePasswordPageModel>(
          builder: (context, model, __) {
        return Scaffold(
            body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BackButton(),
                ReactiveForm(
                  formGroup: model.form,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Text(
                            locale.get("Change Password") ?? "Change Password",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 8,
                        ),
                        ReactiveField(
                          borderColor: Colors.black,
                          enabledBorderColor: Colors.black,
                          secure: _obscureText,
                          type: ReactiveFields.PASSWORD,
                          iconButton: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.red,
                            ),
                            onPressed: () {
                              _obscureText = !_obscureText;
                              print(_obscureText);
                              model.setState();
                            },
                          ),
                          controllerName: 'password',
                          label: locale.get('Password') ?? 'Password',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ReactiveField(
                          borderColor: Colors.black,
                          enabledBorderColor: Colors.black,
                          secure: _obscureText1,
                          type: ReactiveFields.PASSWORD,
                          iconButton: IconButton(
                            icon: Icon(
                              _obscureText1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.red,
                            ),
                            onPressed: () {
                              _obscureText1 = !_obscureText1;
                              print(_obscureText1);
                              model.setState();
                            },
                          ),
                          controllerName: 'confirmPassword',
                          label: locale.get('Confirm Password') ??
                              'Confirm Password',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        model.busy
                            ? ButtonLoading()
                            : NormalButton(
                                onPressed: () {
                                  if (model.form.valid) {
                                    model.changePassword(context);
                                  } else {
                                    model.form.markAllAsTouched();
                                  }
                                },
                                text: "Change Password",
                                color: AppColors.primaryColor,
                                raduis: 1,
                                bold: false,
                              ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
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
}
