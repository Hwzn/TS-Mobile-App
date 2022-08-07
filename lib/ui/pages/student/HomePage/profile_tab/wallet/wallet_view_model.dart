import 'package:flutter/cupertino.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/Bank_Account_model.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class WalletPageModel extends BaseNotifier {
  FormGroup form;
  AuthenticationService auth;
  final BuildContext context;
  final AppLocalizations locale;

  BankAccount selctedAccount;

  List<BankAccount> bankAccounts = [];
  WalletPageModel(this.context, this.locale) {
    getBankAccounts();
    auth = locator<AuthenticationService>();
    form = FormGroup(
      {
        'accountId': FormControl(
          value: null,
          validators: [
            Validators.required,
          ],
        ),
        'value': FormControl<int>(
          value: 0,
          validators: [
            Validators.required,
          ],
        ),
      },
    );
  }

  void getBankAccounts() async {
    setBusy();
    var res = await api.getTeacherBankAccounts(context);
    res.fold((error) {
      UI.toast(error.message);
      setError();
    }, (data) {
      bankAccounts =
          data.map<BankAccount>((item) => BankAccount.fromJson(item)).toList();
      setIdle();
    });
  }

  applyToWithdraw() async {
    setBusy();
    var res = await api.applyToWithdrawCash(
        context, form.value['accountId'], form.value['value']);
    res.fold((error) {
      UI.toast(error.message);
      setError();
    }, (data) async {
      var updatedUser = await api.myProfile(context);
      if (updatedUser != null) {
        updatedUser.fold((e) => ErrorWidget(e), (d) {
          locator<AuthenticationService>().saveUser(User.fromJson(d));
        });
      }
      Navigator.of(context).pop();

      setIdle();
    });
  }
}
