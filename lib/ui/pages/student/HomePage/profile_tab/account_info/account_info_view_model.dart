import 'package:flutter/cupertino.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/services/preference/preference.dart';
import 'package:ts_academy/ui/routes/ui.dart';

import '../../../../../../core/models/city_model.dart';
import '../../../../../../core/providers/provider_setup.dart';
import '../../../../../../core/services/auth/authentication_service.dart';
import '../../../../../../core/services/localization/localization.dart';

class AccountInfoPageModel extends BaseNotifier {
  final BuildContext context;
  final AppLocalizations locale;

  FormGroup form;
  AuthenticationService auth;

  AccountInfoPageModel(this.context, this.locale) {
    auth = locator<AuthenticationService>();
    getCity(context);
    form = FormGroup(
      {
        'name': FormControl(
          value: auth.user.name,
          validators: [
            Validators.required,
          ],
        ),
        'phoneNumber': FormControl(
          value: auth.user.phone,
          validators: [
            Validators.required,
          ],
        ),
        'email': FormControl(
          value: auth.user.email,
          validators: [
            Validators.required,
          ],
        ),
        'city': FormControl(
          // value: auth.user.student.city.sId,
          value: auth.user?.city?.sId ?? null,
          validators: [
            Validators.required,
          ],
        ),
        "fcmToken": FormControl(value: Preference.getString(PrefKeys.fcmToken)),
      },
    );
  }

  List<City> cities = [];

  updateUser() async {
    if (form.valid) {
      setBusy();
      bool result = await auth.updateUserProfile(context, body: form.value);
      if (result) {
        UI.showSnackBarMessage(
          context: context,
          message: locale.get("Profile has been updated"),
        );
        Navigator.of(context).pop();
      } else {
        UI.toast("Something went wrong please try again later.");
      }
      setIdle();
    } else {
      print("form not valid");
    }
  }

  void getCity(context) async {
    setBusy();
    var res = await api.getAllCities(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      cities = data.map<City>((item) => City.fromJson(item)).toList();
      setIdle();
    });
  }
}
