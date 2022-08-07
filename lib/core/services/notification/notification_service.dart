import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/services/preference/preference.dart';
import 'package:ts_academy/ui/widgets/notification_widget.dart';

import '../auth/authentication_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*
* 🦄initiated at the app start to listen to notifications..
*/
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

class NotificationService extends BaseNotifier {
  final AuthenticationService auth;
  List<dynamic> userNotifications;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  NotificationService({this.auth});
  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String token = await messaging.getToken();
    print("Firebase token : $token");
    Preference.setString(PrefKeys.fcmToken, token);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Logger().wtf(message);
      // Logger().w(message.data);
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      if (notification != null) {
        operateOnMessage(notification.title, notification.body);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('A new onMessage event was published!');

      RemoteNotification notification = message.notification;
      if (notification != null) {
        operateOnMessage(notification.title, notification.body);
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    // });
  }

  // Future<void> updateFCMToken(token) async {
  //   if (token != null) {
  //     try {
  //       //TODO: update fcm implementation
  //       // Preference.setString(PrefKeys.fcmToken, token);

  //       // print('new fcm:$token');
  //     } catch (e) {
  //       print('error updating fcm');
  //     }
  //   }
  // }

  operateOnMessage(String mtitle, String mBody, {Map data}) async {
    // Logger().wtf('Operating Message:\n $mtitle $mBody');

    showOverlayNotification((context) {
      return NotificationWidget(
        title: mtitle,
        body: mBody,
        data: data,
        key: UniqueKey(),
      );
    }, duration: Duration(seconds: 8));
  }

  getIOSPermission() async {
    await _firebaseMessaging.requestPermission(
        announcement: true, criticalAlert: true, provisional: true);
    // (const IosNotificationSettings(
    //     sound: true, badge: true, alert: true, provisional: true));

    // final iosSubscription = _firebaseMessaging.onIosSettingsRegistered.listen((data) {
    //       _saveDeviceToken();
    //     });
  }
}
