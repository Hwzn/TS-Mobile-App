import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/bank_accounts/bank_account_view_model.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';

class AddAccountPage extends StatefulWidget {
  BankAccountsPageModel model;
  AddAccountPage({Key key, this.model}) : super(key: key);

  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return ChangeNotifierProvider<BankAccountsPageModel>.value(
        value: widget.model,
        child: Consumer<BankAccountsPageModel>(builder: (context, model, __) {
          return SingleChildScrollView(
            child: Container(
              height: SizeConfig.heightMultiplier * 80,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: SizeConfig.widthMultiplier * 40,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.grey[400]),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ReactiveForm(
                    formGroup: model.form,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          ReactiveField(
                            context: context,
                            borderColor: AppColors.borderColor,
                            enabledBorderColor: Colors.black,
                            // hintColor: AppColors.borderColor,
                            // textColor: AppColors.greyColor,
                            type: ReactiveFields.TEXT,
                            controllerName: 'accountNumber',

                            keyboardType: TextInputType.number,
                            label: locale.get('Account Number') ??
                                'Account Number',
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
                            type: ReactiveFields.TEXT,
                            controllerName: 'bankName',

                            label: locale.get('Bank Name') ?? 'Bank Name',
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
                            type: ReactiveFields.TEXT,
                            controllerName: 'accountHolderName',
                            label: locale.get('Account Name') ?? 'Account Name',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NormalButton(
                      text: "Apply",
                      color: AppColors.primaryColor,
                      onPressed: () {
                        if (model.form.valid) {
                          model.addBankAccounts(context);
                        } else {
                          model.form.markAllAsTouched();
                        }
                      },
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
