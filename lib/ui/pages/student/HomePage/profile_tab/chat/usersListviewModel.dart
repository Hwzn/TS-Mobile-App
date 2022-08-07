import 'package:flutter/cupertino.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class UsersListViewModel extends BaseNotifier {
  BuildContext context;
  List<User> users;
  void getAlluUser() async {
    setBusy();
    if (locator<AuthenticationService>().user.userType == "Teacher") {
      var res = await api.getAllTeachers(context);
      res.fold((error) {
        UI.toast(error.message);
        setError();
      }, (data) {
        users = data.map<User>((item) => User.fromJson(item)).toList();
        setIdle();
      });
    } else {
      var res = await api.getAllTeachers(context);
      res.fold((error) {
        setError();
        UI.toast(error.message);
      }, (data) {
        users = data.map<User>((item) => User.fromJson(item)).toList();
        setIdle();
      });
    }
  }
}
