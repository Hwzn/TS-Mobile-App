import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/pricing.service.dart';
import 'package:ts_academy/ui/pages/shared/on_boardingPage/onBoardingModel.dart';
import 'package:ts_academy/ui/pages/student/HomePage/MainHome/main_home_view.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class OnBoardingViewModel extends BaseNotifier {
  List<OnBoardingModel> onBoarding;
  BuildContext context;
  OnBoardingViewModel() {
    getOnBoarding();
  }
  void getOnBoarding() async {
    setBusy();
    var res = await api.getOnBoarding(context);
    res.fold((error) {
      UI.toast(error.message);
      setError();
    }, (data) {
      onBoarding = data
          .map<OnBoardingModel>((item) => OnBoardingModel.fromJson(item))
          .toList();
      setIdle();
    });
  }

  Future<void> requestToken() async {
    await locator<PricingService>().getPricing();

    String identifier = await getDeviceDetails();

    await api
        .request(EndPoint.requestToken + identifier,
            headers: Header.clientAuth, body: {}, type: RequestType.Put)
        .then((res) => res.fold((err) {
              print(err);
              UI.toast('can not login as guest');
            }, (data) {
              locator<AuthenticationService>().saveToken(data['token']);
            }));
  }

  static Future<String> getDeviceDetails() async {
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;

        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return identifier;
  }
}
