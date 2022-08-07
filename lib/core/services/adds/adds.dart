// import 'package:firebase_admob/firebase_admob.dart';

// class Adds {
//   Adds._internal() {
//     FirebaseAdMob.instance
//         .initialize(appId: "ca-app-pub-6477278662672544~7624942022");
//   }
//   static final Adds instance = Adds._internal();

//   String testDevice = "";
//   static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
//     testDevices: <String>[],
//     keywords: <String>['inventory', 'scanner', 'qunter'],
//     childDirected: true,
//   );
//   BannerAd _bannerAd;
//   InterstitialAd _interstitialAd;

//   void showBanner() {
//     _bannerAd = createBannerAdd()
//       ..load()
//       ..show(anchorOffset: 90.0, anchorType: AnchorType.top);
//   }

//   void showFullScreen() {
//     _interstitialAd = createInterstitialAd()
//       ..load()
//       ..show();
//   }

//   void closeBanner() {
//     _bannerAd.dispose();
//   }

//   void closeFullScreen() {
//     _interstitialAd.dispose();
//   }

//   InterstitialAd createInterstitialAd() {
//     return InterstitialAd(
//         adUnitId: "ca-app-pub-6477278662672544/4718194195",
//         targetingInfo: targetInfo,
//         listener: (MobileAdEvent event) {
//           print("banner event: $event");
//         });
//   }

//   BannerAd createBannerAdd() {
//     return BannerAd(
//         adUnitId: "ca-app-pub-6477278662672544/1627328122",
//         size: AdSize.largeBanner,
//         targetingInfo: targetInfo,
//         listener: (MobileAdEvent event) {
//           print("banner event: $event");
//         });
//   }
// }
