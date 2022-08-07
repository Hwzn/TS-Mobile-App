import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/models/Bank_Account_model.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/bank_accounts/add_Bank_Account/add_bank_account_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/bank_accounts/bank_account_view_model.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/widgets/loading.dart';

class BankAccountsPage extends StatefulWidget {
  const BankAccountsPage({Key key}) : super(key: key);

  @override
  _BankAccountsPageState createState() => _BankAccountsPageState();
}

class _BankAccountsPageState extends State<BankAccountsPage> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<BankAccountsPageModel>(
        create: (context) => BankAccountsPageModel(context: context),
        child: Consumer<BankAccountsPageModel>(builder: (context, model, __) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.primaryColor,
                child: const Icon(Icons.add),
                onPressed: () => {_modalBottomSheetMenu(context, model)},
              ),
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  locale.get("Bank Accounts") ?? "Bank Accounts",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 20),
                ),
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body: Container(
                  child: model.busy
                      ? const Loading()
                      : ListView.builder(
                          itemCount: model.bankAccounts?.length ?? 0,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return card(
                                bankAccount: model.bankAccounts[index],
                                model: model);
                          })));
        }));
  }

  Widget card({BankAccount bankAccount, BankAccountsPageModel model}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: 'Bank Name: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: bankAccount.bankName,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: 'Account Name: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: bankAccount.accountHolderName,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: 'Account Number: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: bankAccount.accountNumber,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryColor),
                  ),
                  onPressed: () {
                    // model.deleteBankAccount(bankAccount.oId);
                    showAlertDialog(context, bankAccount.oId, model);
                  },
                  child: const Text(
                    'Remove',
                    style:
                        TextStyle(color: AppColors.primaryColor, fontSize: 16),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _modalBottomSheetMenu(context, model) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        isScrollControlled: true,
        // enableDrag: true,

        context: context,
        builder: (context) {
          return new Container(
            // height: SizeConfig.heightMultiplier * 100,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: AddAccountPage(
              model: model,
            ),
          );
        });
  }

  void showAlertDialog(
      BuildContext context, String bankAccountId, BankAccountsPageModel model) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text(
                "Remove Bank Account",
                style: TextStyle(color: const Color(0xffE41616)),
              ),
              content: const Text("remove Bank Account from Profile"),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () async {
                      // Logger().w("asdasdasdasd");
                      model.deleteBankAccount(bankAccountId);
                      Navigator.pop(context);
                    },
                    child: const Text("Confirm")),
              ],
            ));
  }
}
