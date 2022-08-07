import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/Bank_Account_model.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/bank_accounts/bank_account_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/wallet/wallet_view_model.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/main_button.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return ChangeNotifierProvider<WalletPageModel>(
        create: (context) => WalletPageModel(context, locale),
        child: Consumer<WalletPageModel>(builder: (context, model, __) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                locale.get("Wallet") ?? "Wallet",
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
            body: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: locale.get('You have') + " ",
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                            TextSpan(
                              text: locator<AuthenticationService>()
                                          .user
                                          .wallet !=
                                      null
                                  ? locator<AuthenticationService>()
                                          .user
                                          .wallet
                                          .fold(
                                              0,
                                              (previousValue, element) =>
                                                  previousValue +
                                                  (element.type == 'in'
                                                      ? element.value
                                                      : element.status ==
                                                              'approved'
                                                          ? element.value
                                                          : 0))
                                          .toString() +
                                      "  " +
                                      locale.get('SR')
                                  : "0" + "  " + locale.get('SR'),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.red),
                            ),
                            TextSpan(
                                text: "  " + locale.get('in your wallet'),
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      Container(
                        height: SizeConfig.heightMultiplier * 70,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    Wallet wallet =
                                        model.auth.user.wallet[index];
                                    return Container(
                                      height: 70,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text.rich(TextSpan(children: [
                                                  TextSpan(
                                                      text: locale.get('Cash'),
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  TextSpan(
                                                      text: ' ${wallet.value}',
                                                      style: TextStyle(
                                                          color: AppColors.red,
                                                          fontSize: 18))
                                                ])),
                                                Text.rich(TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          locale.get('Status') +
                                                              ': ',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  TextSpan(
                                                      text: locale
                                                          .get(wallet.status),
                                                      style: TextStyle(
                                                          color: wallet
                                                                      .status ==
                                                                  'pending'
                                                              ? AppColors.red
                                                              : AppColors
                                                                  .primaryColor,
                                                          fontSize: 18))
                                                ])),
                                              ],
                                            ),
                                            Text(
                                              DateFormat('yyyy-MM-dd hh:mm')
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          wallet.date)),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Container(
                                        height: 0.5, color: Colors.blueGrey);
                                  },
                                  itemCount:
                                      model.auth.user?.wallet?.length ?? 0)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: NormalButton(
                          color: AppColors.primaryColor,
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => new AlertDialog(
                                      content: Container(
                                        height:
                                            SizeConfig.heightMultiplier * 40,
                                        color: Colors.white,
                                        child: ReactiveForm(
                                          formGroup: model.form,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                locale.get("Apply to Withdraw"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(fontSize: 20),
                                              ),
                                              Text(
                                                locale
                                                    .get("Select Bank Account"),
                                              ),
                                              DropdownButton<BankAccount>(
                                                hint: Text(locale.get(
                                                    'Select Bank Account')),
                                                dropdownColor:
                                                    AppColors.accentText,
                                                iconSize: 24,
                                                value: model.selctedAccount,
                                                autofocus: true,
                                                elevation: 16,
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.primaryColor),
                                                underline: Container(
                                                  height: 0.5,
                                                  color: AppColors.primaryColor,
                                                ),
                                                onChanged:
                                                    (BankAccount newValue) {
                                                  if (newValue != null)
                                                    setState(() {
                                                      model.selctedAccount =
                                                          newValue;
                                                      model.form
                                                          .control('accountId')
                                                          .updateValue(model
                                                              .selctedAccount
                                                              .oId);
                                                    });
                                                },
                                                items: [
                                                  ...model.bankAccounts.map<
                                                          DropdownMenuItem<
                                                              BankAccount>>(
                                                      (BankAccount value) {
                                                    return DropdownMenuItem<
                                                        BankAccount>(
                                                      value: value,
                                                      child: Text(
                                                          "${value.bankName} - ${value.accountHolderName} - ${value.accountNumber}"),
                                                    );
                                                  }).toList(),
                                                  DropdownMenuItem(
                                                      child: MainButton(
                                                    text: locale.get(
                                                        'Add Bank Account'),
                                                    onTap: () => {
                                                      UI.push(context,
                                                          BankAccountsPage())
                                                    },
                                                  ))
                                                ],
                                              ),
                                              Text(
                                                locale.get("Enter Amount"),
                                              ),
                                              ReactiveField(
                                                borderColor: Colors.black,
                                                enabledBorderColor:
                                                    AppColors.borderColor,
                                                hintColor: Colors.black,
                                                type: ReactiveFields.TEXT,
                                                controllerName: 'value',
                                                keyboardType:
                                                    TextInputType.number,
                                                hint: locale.get(
                                                    'Enter Amount to request'),
                                                validationMesseges: {
                                                  'min': locale.get(
                                                      'Minimum Value is 0'),
                                                  'max': locale.get(
                                                      'Maximum Value is 100'),
                                                  'required': locale
                                                          .get('value') +
                                                      " " +
                                                      locale.get('is required'),
                                                },
                                              ),
                                              MainButton(
                                                text: locale.get('Send'),
                                                onTap: () async {
                                                  await model.applyToWithdraw();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                          },
                          text: locale.get('Apply to Withdraw'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
