import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/models/promotion.model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import '../../../../../../core/services/localization/localization.dart';

class CartPageModel extends BaseNotifier {
  final BuildContext context;
  final AppLocalizations locale;
  bool isPaymentSuccessful = false;
  double total = 0;
  CartPageModel(this.context, this.locale) {
    getCart();
  }

  void showAlertDialog(courseId) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          locale.get("Remove Course"),
          style: TextStyle(color: Color(0xffE41616)),
        ),
        content: Text(locale.get("remove course from Cart")),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(locale.get("Cancel")),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              deletefromCart(courseId);
              Navigator.pop(context);
            },
            child: Text(locale.get("Confirm")),
          ),
        ],
      ),
    );
  }

  List<Course> courses = [];

  void getCart() async {
    setBusy();
    var res = await api.getStudentCart(context);
    res.fold((error) {
      UI.showSnackBarMessage(context: context, message: error.message);
      setError();
    }, (data) {
      courses = data
          .map<Course>(
            (item) => Course.fromJson(item),
          )
          .toList();
      total = courses.fold(
          0, (previousValue, element) => previousValue + element.basePrice);
      setIdle();
      print("========================");
    });
  }

  void deletefromCart(courseId) async {
    setBusy();
    var res = await api.deleteFromCart(context, courseId: courseId);
    res.fold((error) {
      UI.showSnackBarMessage(context: context, message: error.message);
      setError();
    }, (data) {
      getCart();
      setIdle();
    });
  }
}
