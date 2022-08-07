import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/teacher/auth/register/teacher_page_view_model.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';

import 'package:ts_academy/ui/routes/ui.dart';

class TeacherRegisterPage extends StatelessWidget {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<TeacherRegisterPageModel>(
      create: (context) => TeacherRegisterPageModel(),
      child: Consumer<TeacherRegisterPageModel>(builder: (context, model, __) {
        return Scaffold(
            body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: model.busy
                  ? Loading()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReactiveForm(
                          formGroup: model.form,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Center(
                                  child: Container(
                                    child: Text(
                                      locale.get("Sign up As Teacher") ??
                                          "Sign up As Teacher",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 20),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.heightMultiplier * 8,
                                ),
                                ReactiveField(
                                  borderColor: Colors.black,
                                  enabledBorderColor: AppColors.borderColor,
                                  hintColor: Colors.black,
                                  type: ReactiveFields.TEXT,
                                  controllerName: 'name',
                                  label: locale.get('Name') ?? 'Name',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ReactiveField(
                                  borderColor: Colors.black,
                                  enabledBorderColor: AppColors.borderColor,
                                  hintColor: Colors.black,
                                  type: ReactiveFields.TEXT,
                                  keyboardType: TextInputType.phone,
                                  controllerName: 'phone',
                                  label: locale.get('Phone number') ??
                                      'Phone number',
                                  validationMesseges: {
                                    'required':
                                        locale.get('Mobile number is required'),
                                    'minLength':
                                        locale.get('Check Minimum Length'),
                                    'pattern': locale.get(
                                        'mobile number must be Saudi mobile number')
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ReactiveField(
                                  borderColor: Colors.black,
                                  enabledBorderColor: AppColors.borderColor,
                                  hintColor: Colors.black,
                                  type: ReactiveFields.TEXT,
                                  keyboardType: TextInputType.phone,
                                  controllerName: 'additionalPhone',
                                  label:
                                      locale.get('Additional Phone Number') ??
                                          'Additional Phone Number',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ReactiveField(
                                  borderColor: Colors.black,
                                  enabledBorderColor: AppColors.borderColor,
                                  hintColor: Colors.black,
                                  type: ReactiveFields.TEXT,
                                  controllerName: 'email',
                                  label: locale.get('E-mail') ?? 'E-mail',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ReactiveField(
                                  context: context,
                                  borderColor: AppColors.borderColor,
                                  enabledBorderColor: Colors.black,
                                  // hintColor: AppColors.borderColor,
                                  // textColor: AppColors.greyColor,
                                  items: model.cities,
                                  type: ReactiveFields.DROP_DOWN,
                                  controllerName: 'cityId',
                                  label: locale.get('City') ?? 'City',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: SizeConfig.heightMultiplier * 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.0),
                                    border: Border.all(
                                      color: AppColors.borderColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(locale.get('Upload Resume')),
                                        InkWell(
                                            onTap: () {
                                              model.chooseFile(true);
                                            },
                                            child:
                                                Icon(Icons.attachment_outlined))
                                      ],
                                    ),
                                  ),
                                ),
                                model.resumeName != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      70,
                                              child: Text(
                                                "${model.resumeName ?? ""} ${model.resumeSize ?? ""} ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                        color: AppColors
                                                            .primaryColor),
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  model.resumeName = null;
                                                  model.form
                                                      .control("resume")
                                                      .value = null;
                                                  model.setState();
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      )
                                    : Text(
                                        locale.get('Required'),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: SizeConfig.heightMultiplier * 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.0),
                                    border: Border.all(
                                      color: AppColors.borderColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          locale.get('Cover Letter'),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              model.chooseFile(false);
                                            },
                                            child:
                                                Icon(Icons.attachment_outlined))
                                      ],
                                    ),
                                  ),
                                ),
                                model.coverLetterName != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      70,
                                              child: Text(
                                                "${model.coverLetterName ?? ""} ${model.coverLetterSize ?? ""} ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                        color: AppColors
                                                            .primaryColor),
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  model.coverLetterName = null;
                                                  model.form
                                                      .control("coverLetter")
                                                      .value = null;
                                                  model.setState();
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      )
                                    : Text(
                                        locale.get('Required'),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                SizedBox(
                                  height: 20,
                                ),
                                ReactiveField(
                                  borderColor: Colors.black,
                                  enabledBorderColor: AppColors.borderColor,
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
                                  enabledBorderColor: AppColors.borderColor,
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
                                  controllerName: 'confirmPassword',
                                  label: locale.get('Confirm Password') ??
                                      'Confirm Password',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ReactiveFormConsumer(
                                  builder: (context, formGroup, child) =>
                                      NormalButton(
                                    onPressed: formGroup.valid
                                        ? () {
                                            model.teacherRegister(context);
                                          }
                                        : null,
                                    text: formGroup.valid
                                        ? "Create Acount"
                                        : "Please Fill all required fields",
                                    color: formGroup.valid
                                        ? AppColors.primaryColor
                                        : AppColors.red,
                                    raduis: 2,
                                    bold: false,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(locale.get("Haven an Account? ") ??
                                        "Have an Account? "),
                                    InkWell(
                                      onTap: () {
                                        UI.push(context, StudentLoginPage());
                                      },
                                      child: Text(
                                        "Sign in",
                                        style: TextStyle(
                                            color: AppColors.primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ));
      }),
    );
  }
}
