import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ts_academy/core/models/server_error.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/services/pricing.service.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';
import 'package:ts_academy/ui/pages/video/call.dart';
import 'package:ts_academy/ui/widgets/ErrorDialog.dart';
import '../../../../../../core/models/course.dart';
import '../../../../../../core/providers/provider_setup.dart';
import '../../../../../../core/services/auth/authentication_service.dart';
import '../../../../../../core/services/localization/localization.dart';
import '../../../../../routes/ui.dart';

class CoursePageModel extends BaseNotifier {
  final BuildContext context;
  final AppLocalizations locale;
  final String courseId;
  final bool isMyCourse;
  final TabController _tabController;
  Course course;
  int exercisesCount = 0;

  AuthenticationService auth;

  bool reviewsTabActive = true;
  CoursePageModel(this.context, this.locale, this._tabController,
      {this.courseId, this.isMyCourse = false}) {
    auth = locator<AuthenticationService>();
    getCourseById();
  }

  chooseFile(String lessonId, String courseId) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      uploadFile(context, file.path, lessonId, courseId);
      setState();
    } else {
      const ErrorDialog().notification(
        locale.get("An Error Occurred"),
        Colors.red,
      );
    }
  }

  uploadFile(BuildContext context, String filePath, String lessonId,
      String courseId) async {
    var res = await api.uploadFile(context, file: filePath);
    res.fold((e) => UI.toast(e.message), (data) async {
      // Logger().wtf(data);
      var res = await api
          .applyAssignment(context, courseId, lessonId, [data['path']]);
      if (res != null) {
        res.fold(
            (error) => ErrorWidget(error),
            (d) => UI.showSnackBarMessage(
                  context: context,
                  message: locale.get('Assignment Submitted Successfully'),
                ));
      }
    });
    setState();
  }

  void getCourseById() async {
    setBusy();
    final res = await api.getCourseById(context, courseId: courseId);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      if (data != null) {
        print("Course: =>> $data");
        course = Course.fromJson(data);
        // for (int i = 0; i < course.content.length; i++) {
        //   for (int j = 0; j < course.content[i].lessons.length; j++) {
        //     if (course.content[i].lessons[j].type == "excercice") {
        //       exercisesCount++;
        //     }
        //   }
        // }
      }
      setIdle();
    });
  }

  void subscribe(Course course) async {
    if (course.type != 'home') {
      await inAppPurchase(course);
    } else {
      await addToCart();
    }
  }

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  GoogleSignInAuthentication googleCred;

  inAppPurchase(Course course) async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      UI.showSnackBarMessage(
          context: context,
          message: locale.get(
              'Please Confirm in app purchase is available for your device and country'));
      // The store cannot be reached or accessed. Update the UI accordingly.
    } else {
      PurchaseParam purchaseParam;
      if (course.type == 'session') {
        purchaseParam =
            PurchaseParam(productDetails: locator<PricingService>().session);
      }
      if (course.type == 'tutorial') {
        purchaseParam =
            PurchaseParam(productDetails: locator<PricingService>().tutorial);
      }
      try {
        locator<PricingService>().listenToSubscription();
        setBusy();
        if (Platform.isAndroid) {
          try {
            googleCred = await auth.signInWithGoogle();
          } on PlatformException {
            print('message');
            setError();
            return;
          }
          ;
        }
        bool purchasingInitiated = await InAppPurchase.instance
            .buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
        if (!purchasingInitiated) {
          setIdle();
        }
        locator<PricingService>().subscription.onData((data) async {
          var purchaseDetails = data.first;
          if (purchaseDetails.status == PurchaseStatus.pending) {
            Logger().wtf('pending', purchaseDetails);
            // _showPendingUI();
            setIdle();
          } else {
            if (purchaseDetails.status == PurchaseStatus.error) {
              Logger().wtf('error', purchaseDetails);
              setError();
            } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                purchaseDetails.status == PurchaseStatus.restored) {
              bool valid = await verifyPurchase(purchaseDetails);
              if (valid) {
                Logger().wtf('verify', purchaseDetails);
                setIdle();
              } else {
                return;
              }
            }
            if (purchaseDetails.pendingCompletePurchase) {
              await InAppPurchase.instance.completePurchase(purchaseDetails);
            }
            setIdle();
          }
        });
        locator<PricingService>().subscription.onError((error) {
          Logger().wtf(error);
          setIdle();
        });
        locator<PricingService>().subscription.onDone(() {
          Logger().wtf('done');
          setIdle();
        });
      } catch (e) {
        setIdle();
        Logger().wtf(e);
      }

      print(available);
    }
  }

  addToCart() async {
    setBusy();
    final res = await api.addToCart(context, courseId: courseId);
    res.fold((error) {
      UI.toast(error.message.toString());
      setError();
    }, (data) {
      if (data != null) {
        // course.inCart = true;
        UI.showSnackBarMessage(
          context: context,
          message: locale.get("Course has been added to your cart."),
        );
        pushNewScreen(context,
            screen: CartPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false);

        setState();
      }
      setIdle();
    });
  }

  void showAlertDialog(CoursePageModel model, Lessons lesson) {
    String userType = locator<AuthenticationService>().user.userType;

    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          locale.get(userType == 'Teacher' ? "Start live" : "Join Live"),
          style: TextStyle(color: Color(0xffE41616)),
        ),
        content: Text(locale.get(userType == 'Teacher'
            ? "are you sure you want to start live"
            : "are you sure you want to join live")),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(locale.get("Cancel")),
          ),
          CupertinoDialogAction(
            isDefaultAction: false,
            isDestructiveAction: true,
            onPressed: () async {
              var result;

              switch (userType) {
                case 'Teacher':
                  result = await api.startLive(
                    context,
                    body: {
                      "token":
                          "Bearer ${locator<AuthenticationService>().user.token}",
                      "courseId": courseId,
                      "lessonId": lesson.oId
                    },
                  );
                  break;
                case 'Student':
                  result = await api.joinLive(
                    context,
                    body: {
                      "token":
                          "Bearer ${locator<AuthenticationService>().user.token}",
                      "courseId": courseId,
                      "lessonId": lesson.oId
                    },
                  );
                  break;
                default:
                  break;
              }

              if (result != null) {
                result.fold((ServerError e) {
                  Navigator.pop(context);
                  ErrorDialog().notification(
                    locale.get(e.message),
                    Colors.redAccent,
                  );
                }, (d) async {
                  // Logger().d(d);
                  dynamic liveToken = userType == 'Teacher'
                      ? d["teacherToken"]
                      : d["studentToken"];
                  Navigator.pop(context);

                  pushNewScreen(context,
                      screen: CallPage(
                          // lesssonId: lessonId,
                          // courseId: model.courseId,
                          course: course,
                          liveToken: liveToken),
                      withNavBar: false);
                });
              }
            },
            child: Text(locale.get("Confirm")),
          ),
        ],
      ),
    );
  }

  Future<void> writeReview(Map<String, Object> reviewBody) async {
    setBusy();
    final res =
        await api.writeReview(context, courseId: courseId, body: reviewBody);
    res.fold((error) {
      UI.toast(error.message.toString());
      setError();
    }, (data) {
      if (data != null) {
        UI.toast(
          locale.get('thank you for your review'),
        );
        Navigator.pop(context);
        getCourseById();
        _tabController.animateTo(0);
        setState();
      }
      setIdle();
    });
  }
}
