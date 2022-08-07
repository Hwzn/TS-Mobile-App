import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ts_academy/core/models/user_model.dart' as UserModel;
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/ui/routes/ui.dart';

import '../preference/preference.dart';

class AuthenticationService extends BaseNotifier {
  //for testing only remove the init
  UserModel.User _user;

  UserModel.User get user => _user;

  /*
   *check if user is authenticated
   */
  bool get userLoged => Preference.getBool(PrefKeys.userLogged) ?? false;

  /*
   *save user in shared prefrences
   */
  saveUser(UserModel.User user) {
    Preference.setString(PrefKeys.userData, json.encode(user.toJson()));
    Preference.setString(PrefKeys.token, user.token);
    Preference.setBool(PrefKeys.userLogged, true);
    _user = user;
    // Logger().i(json.encode(user.toJson()));
  }

  saveToken(String token) {
    Preference.setString(PrefKeys.token, token);
    Preference.setBool(PrefKeys.userLogged, false);
    _user = null;
  }

  updateUserProfile(BuildContext context, {Map<String, dynamic> body}) async {
    var res = await api.updateUserProfile(
      context,
      body: body,
    );
    UserModel.User user;
    res.fold((error) {
      UI.toast(error.message);
    }, (data) {
      print(data);
      user = UserModel.User.fromJson(data);
      if (user != null) {
        saveUser(user);
      }
    });
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  saveFirstToken(String token) {
    _user = UserModel.User(token: token);
  }

  /*
   * load the user info from shared prefrence if existed to be used in the service
   */
  Future<void> get loadUser async {
    _user = UserModel.User.fromJson(
        json.decode(Preference.getString(PrefKeys.userData)));
    // Logger().i(json.encode(_user.toJson()));
    // Logger().i("TOKEN:  " + _user.token);
  }

  //  login with user name and pass

  /*
   * signout the user from the app and return to the login screen   
   */
  Future<void> get signOut async {
    await Preference.sb.clear();
    _user = null;
  }

  static handleAuthExpired({@required BuildContext context}) async {
    if (context != null) {
      try {
        // Logger().v('🦄ready to destroy session🦄');

        Preference.setBool(PrefKeys.userLogged, false);

        // UI.pushReplaceAll(context, Routes.splashScreen);

        // Logger().v('🦄session destroyed🦄');
      } catch (e) {
        // Logger().v('🦄error while destroying session🦄');
        // Logger().v('🦄$e🦄');
      }
    }
  }

  Future<GoogleSignInAuthentication> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn(
        scopes: ['https://www.googleapis.com/auth/androidpublisher']).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return googleAuth;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
}
