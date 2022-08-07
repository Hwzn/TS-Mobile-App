import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/teacher/auth/register/teacher_page_view.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';
import 'package:ts_academy/ui/widgets/button_loading.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';

import 'package:ts_academy/ui/routes/ui.dart';

import 'register_page_view_model.dart';

class StudentRegisterPage extends StatelessWidget {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<StudentRegisterPageModel>(
      create: (context) => StudentRegisterPageModel(context),
      child: Consumer<StudentRegisterPageModel>(builder: (context, model, __) {
        return Scaffold(
            body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: model.busy
                  ? const Loading()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReactiveForm(
                          key: _formKey,
                          formGroup: model.form,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    locale.get(
                                            "Sign up as ${model.isParent ? "Parent" : "Student"}") ??
                                        "Sign up as ${model.isParent ? "Parent" : "Student"}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(fontSize: 20),
                                    textAlign: TextAlign.center,
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
                                  keyboardType: TextInputType.name,
                                  controllerName: 'name',
                                  label: locale.get('Name') ?? 'Name',
                                ),
                                const SizedBox(
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
                                const SizedBox(
                                  height: 20,
                                ),
                                ReactiveField(
                                  borderColor: Colors.black,
                                  enabledBorderColor: AppColors.borderColor,
                                  hintColor: Colors.black,
                                  type: ReactiveFields.TEXT,
                                  keyboardType: TextInputType.emailAddress,
                                  controllerName: 'email',
                                  validationMesseges: const {
                                    ValidationMessage.required:
                                        'The email must not be empty',
                                    'email':
                                        'The email value must be a valid email'
                                  },
                                  label: locale.get('E-mail') ?? 'E-mail',
                                ),
                                const SizedBox(
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
                                const SizedBox(
                                  height: 20,
                                ),
                                model.isParent
                                    ? ReactiveField(
                                        borderColor: Colors.black,
                                        enabledBorderColor:
                                            AppColors.borderColor,
                                        hintColor: Colors.black,
                                        type: ReactiveFields.TEXT,
                                        keyboardType: TextInputType.number,
                                        controllerName: 'studentId',
                                        label: locale.get('Student ID') ??
                                            'Student ID',
                                      )
                                    : Column(
                                        children: [
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
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ReactiveField(
                                            context: context,
                                            borderColor: AppColors.borderColor,
                                            enabledBorderColor:
                                                AppColors.borderColor,
                                            hintColor: AppColors.borderColor,
                                            textColor: AppColors.greyColor,
                                            items: model.stages,
                                            type: ReactiveFields.DROP_DOWN,
                                            controllerName: 'stageId',
                                            label: locale.get('Stage'),
                                            onchange: (value) {
                                              print(value);
                                              model.getGrades(context);
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ReactiveValueListenableBuilder<
                                              String>(
                                            formControlName: 'stageId',
                                            builder: (context, control, child) {
                                              return control.valid
                                                  ? ReactiveField(
                                                      context: context,
                                                      borderColor:
                                                          AppColors.borderColor,
                                                      enabledBorderColor:
                                                          AppColors.borderColor,
                                                      hintColor:
                                                          AppColors.borderColor,
                                                      textColor:
                                                          AppColors.greyColor,
                                                      items: model.grades,
                                                      type: ReactiveFields
                                                          .DROP_DOWN,
                                                      controllerName: 'gradeId',
                                                      label:
                                                          locale.get('Grade'))
                                                  : const SizedBox();
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                                model.busy
                                    ? const ButtonLoading()
                                    : ReactiveFormConsumer(
                                        builder: (context, form, child) {
                                          return NormalButton(
                                            onPressed: () {
                                              if (form.valid) {
                                                if (model.isParent) {
                                                  model.parentRegister(context);
                                                } else {
                                                  model
                                                      .studentRegister(context);
                                                }
                                              }
                                            },
                                            text: form.valid
                                                ? locale.get('Create Acount')
                                                : locale.get(
                                                    'Please Enter Required Fields'),
                                            color: form.valid
                                                ? AppColors.primaryColor
                                                : AppColors.red,
                                            raduis: 2,
                                            bold: false,
                                          );
                                        },
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ButtonTheme(
                                          shape: Border.all(
                                              color: AppColors.primaryColor),
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                              color: AppColors.primaryColor,
                                              style: BorderStyle.solid,
                                              width: 0.5,
                                            ),
                                            ),
                                            child: Text(
                                              model.isParent
                                                  ? locale
                                                      .get('Sign up as student')
                                                  : locale
                                                      .get('Sign up as parent'),
                                              textAlign: TextAlign.center,
                                            ),
                                            // color: AppColors.primaryColor,
                                            // height: 40,
                                            // style: ButtonStyle(),

                                            onPressed: () {
                                              if (model.isParent) {
                                                model.isParent = false;
                                                model.setState();
                                              } else {
                                                model.isParent = true;
                                                model.setState();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ButtonTheme(
                                          shape: Border.all(
                                              color: AppColors.primaryColor),
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                              color: AppColors.primaryColor,
                                              style: BorderStyle.solid,
                                              width: 0.5,
                                            ),
                                            ),                                            
                                            child: Text(
                                              locale.get('Sign up as teacher'),
                                            ),
                                            // color: AppColors.primaryColor,
                                            // height: 40,
                                            // style: ButtonStyle(),

                                            onPressed: () {
                                              UI.push(context,
                                                  TeacherRegisterPage());
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(locale.get("Have an Account?")),
                                    InkWell(
                                      onTap: () {
                                        UI.push(context, StudentLoginPage());
                                      },
                                      child: Text(
                                        locale.get('Sign in'),
                                        style: const TextStyle(
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
