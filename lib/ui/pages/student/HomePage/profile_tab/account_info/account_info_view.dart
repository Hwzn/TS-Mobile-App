import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/main_progress_indicator.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';
import 'account_info_view_model.dart';

class AccountInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<AccountInfoPageModel>(
      create: (context) => AccountInfoPageModel(context, locale),
      child: Consumer<AccountInfoPageModel>(builder: (context, model, __) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                locale.get("Account Info"),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 20),
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
                child: model.busy
                    ? MainProgressIndicator()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ReactiveForm(
                              formGroup: model.form,
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  children: <Widget>[
                                    ReactiveField(
                                      borderColor: Colors.black,
                                      enabledBorderColor: AppColors.borderColor,
                                      hintColor: Colors.black,
                                      type: ReactiveFields.TEXT,
                                      controllerName: 'name',
                                      label: locale.get('Name'),
                                    ),
                                    SizedBox(height: 20),
                                    ReactiveField(
                                      borderColor: Colors.black,
                                      enabledBorderColor: AppColors.borderColor,
                                      hintColor: Colors.black,
                                      type: ReactiveFields.TEXT,
                                      controllerName: 'email',
                                      label: locale.get('E-mail'),
                                    ),
                                    SizedBox(height: 20),
                                    ReactiveField(
                                      borderColor: Colors.black,
                                      enabledBorderColor: AppColors.borderColor,
                                      hintColor: Colors.black,
                                      type: ReactiveFields.TEXT,
                                      controllerName: 'phoneNumber',
                                      label: locale.get('Phone number'),
                                    ),
                                    SizedBox(height: 20),
                                    ReactiveField(
                                      context: context,
                                      borderColor: Colors.black,
                                      hintColor: Colors.black,
                                      enabledBorderColor: AppColors.borderColor,
                                      items: model.cities,
                                      type: ReactiveFields.DROP_DOWN,
                                      controllerName: 'city',
                                      label: locale.get('City') ?? 'City',
                                    ),
                                    SizedBox(height: 20),
                                    NormalButton(
                                      text: locale.get("Save Changes"),
                                      color: AppColors.primaryColor,
                                      raduis: 2,
                                      bold: false,
                                      onPressed: () {
                                        model.updateUser();
                                      },
                                    ),
                                    SizedBox(height: 50),
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
