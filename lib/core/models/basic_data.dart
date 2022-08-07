import 'package:flutter/material.dart';
import 'package:ts_academy/core/services/localization/localization.dart';



class Name {
  String ar;
  String en;

  Name({this.ar, this.en});

  Name.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }

  String localized(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return locale.locale == Locale("en") ? en : ar;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    return data;
  }
}

