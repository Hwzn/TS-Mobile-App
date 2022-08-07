import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:ts_academy/core/models/pricing.model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class PricingService extends BaseNotifier {
  Pricing pricing;
  ProductDetails session;
  ProductDetails tutorial;
  StreamSubscription<List<PurchaseDetails>> subscription;

  getPricing() async {
    var res = await api.request(EndPoint.pricing,
        headers: Header.clientAuth, retry: true);
    res.fold((error) {
      UI.toast(error.message);
      setError();
    }, (data) async {
      pricing = Pricing.fromJson(data);

      String sessionKid = Platform.isAndroid
          ? pricing.sessionAndroidId
          : Platform.isIOS
              ? pricing.sessionAppleId
              : '';
      String tutorialKid = Platform.isAndroid
          ? pricing.tutorialAndroidId
          : Platform.isIOS
              ? pricing.tutorialAppleId
              : '';

      final ProductDetailsResponse sessionResponse =
          await InAppPurchase.instance.queryProductDetails({sessionKid});
      final ProductDetailsResponse tutorialResponse =
          await InAppPurchase.instance.queryProductDetails({tutorialKid});

      session = sessionResponse.notFoundIDs.isEmpty
          ? sessionResponse.productDetails.first
          : null;
      tutorial = tutorialResponse.notFoundIDs.isEmpty
          ? tutorialResponse.productDetails.first
          : null;

      notifyListeners();
      notifyListeners();
      setState();
    });
  }

  listenToSubscription() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    subscription = purchaseUpdated.listen((purchaseDetailsList) {}, onDone: () {
      subscription.cancel();
    }, onError: (error) {
      // handle error here.
      Logger().wtf(error);
    });
  }
}
