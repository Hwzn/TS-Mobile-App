import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/api/http_api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';

class ContactUs extends StatelessWidget {
  ContactUs({Key key}) : super(key: key);
  FormGroup form = new FormGroup({
    "name": new FormControl(
        value: locator<AuthenticationService>()?.user?.name ?? null,
        validators: [Validators.required]),
    "email": new FormControl(
        value: locator<AuthenticationService>()?.user?.email ?? null,
        validators: [Validators.required]),
    "phone": new FormControl(
        value: locator<AuthenticationService>()?.user?.phone ?? null,
        validators: [Validators.required]),
    "subject": new FormControl(validators: [Validators.required]),
    "message": new FormControl(validators: [Validators.required])
  });
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final locale = AppLocalizations.of(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            locale.get('Contact Us'),
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReactiveForm(
                    key: _formKey,
                    formGroup: form,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              locale.get("Contact Us"),
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
                            enabledBorderColor: AppColors.borderColor,
                            hintColor: Colors.black,
                            type: ReactiveFields.TEXT,
                            keyboardType: TextInputType.name,
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
                            label: locale.get('Phone number') ?? 'Phone number',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ReactiveField(
                            borderColor: Colors.black,
                            enabledBorderColor: AppColors.borderColor,
                            hintColor: Colors.black,
                            type: ReactiveFields.TEXT,
                            keyboardType: TextInputType.emailAddress,
                            controllerName: 'email',
                            validationMesseges: {
                              ValidationMessage.required:
                                  'The email must not be empty',
                              'email': 'The email value must be a valid email'
                            },
                            label: locale.get('E-mail') ?? 'E-mail',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ReactiveField(
                            borderColor: Colors.black,
                            enabledBorderColor: AppColors.borderColor,
                            hintColor: Colors.black,
                            type: ReactiveFields.TEXT,
                            keyboardType: TextInputType.text,
                            controllerName: 'subject',
                            label: locale.get('Message Subject'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ReactiveField(
                            borderColor: Colors.black,
                            enabledBorderColor: AppColors.borderColor,
                            hintColor: Colors.black,
                            type: ReactiveFields.TEXT,
                            keyboardType: TextInputType.text,
                            controllerName: 'message',
                            maxLines: 6,
                            label: locale.get('Message'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ReactiveFormConsumer(
                            builder: (context, form, child) {
                              return NormalButton(
                                onPressed: () {
                                  if (form.valid) {
                                    contactUs(context, locale);
                                  }
                                },
                                text: form.valid
                                    ? locale.get('Send Message')
                                    : locale
                                        .get('Please Enter Required Fields'),
                                color: form.valid
                                    ? AppColors.primaryColor
                                    : AppColors.red,
                                raduis: 2,
                                bold: false,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void contactUs(context, locale) {
    locator<HttpApi>()
        .request(EndPoint.CONTACTUS,
            type: RequestType.Post, headers: Header.userAuth, body: form.value)
        .then((rsponse) => rsponse.fold(
            (error) => UI.toast(error.message),
            (data) => {
                  UI.toast(
                    locale.get('Message Sent Successfullty'),
                  ),
                  Navigator.of(context).pop()
                }));
  }
}
