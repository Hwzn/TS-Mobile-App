import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../preference/preference.dart';

class AppLanguageModel extends ChangeNotifier {
  Locale _appLocale = Locale('en');
  Locale get appLocal => _appLocale ?? Locale("en");

  fetchLocale() async {
    if (Preference.getString(PrefKeys.languageCode) == null) {
      _appLocale = Locale('en');
    } else {
      _appLocale = Locale(Preference.getString(PrefKeys.languageCode));
    }
    notifyListeners();

    return null;
  }

  void changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }

    if (type == Locale("ar")) {
      _appLocale = Locale("ar");
      await Preference.setString(PrefKeys.languageCode, 'ar');
      await Preference.setString('countryCode', 'ar');
    } else if (type == Locale("en")) {
      _appLocale = Locale("en");
      await Preference.setString(PrefKeys.languageCode, 'en');
    }
    notifyListeners();
  }
}

class AppLocalizations {
  final Locale locale;

  TextDirection get textDirection =>
      locale.languageCode == 'en' ? TextDirection.ltr : TextDirection.rtl;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString = await rootBundle
        .loadString('assets/languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String get(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
