import 'package:flutter/cupertino.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/Bank_Account_model.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class BankAccountsPageModel extends BaseNotifier {
  BuildContext context;
  FormGroup form;

  BankAccountsPageModel({this.context}) {
    form = FormGroup({
      "accountNumber": FormControl(validators: [
        Validators.required,
        Validators.minLength(10),
        // Validators.maxLength(10),
      ]),
      "bankName": FormControl(validators: [Validators.required]),
      "accountHolderName": FormControl(validators: [Validators.required]),
    });
    getBankAccounts();
  }
  List<BankAccount> bankAccounts;
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

  void deleteBankAccount(String bankAccountId) async {
    // setBusy();
    var res = await api.deleteTeacherBankAccount(context,
        bankAccountId: bankAccountId);
    res.fold((error) {
      UI.toast(error.message);
      setError();
    }, (data) async {
      getBankAccounts();
      var updatedUser = await api.myProfile(context);
      if (updatedUser != null) {
        updatedUser.fold((e) => ErrorWidget(e), (d) {
          locator<AuthenticationService>().saveUser(User.fromJson(d));
        });
      }
      setIdle();
    });
  }

  void addBankAccounts(context) async {
    var res = await api.addBankAccounts(context, body: form.value);
    res.fold((error) {
      UI.toast(error.message);
    }, (data) async {
      getBankAccounts();
      var updatedUser = await api.myProfile(context);
      if (updatedUser != null) {
        updatedUser.fold((e) => ErrorWidget(e), (d) {
          locator<AuthenticationService>().saveUser(User.fromJson(d));
        });
      }
      Navigator.pop(context);
    });
  }
}
