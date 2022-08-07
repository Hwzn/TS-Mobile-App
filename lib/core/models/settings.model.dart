import 'package:ts_academy/core/models/basic_data.dart';

class Settings {
  String phoneNumber;
  String whatsapp;
  String instagram;
  String snapchat;
  String twitter;
  String facebook;
  Name about;
  Name terms;
  Name privacy;

  Settings(
      {this.phoneNumber,
      this.whatsapp,
      this.instagram,
      this.snapchat,
      this.twitter,
      this.facebook,
      this.about,
      this.terms,
      this.privacy});

  Settings.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    whatsapp = json['whatsapp'];
    instagram = json['instagram'];
    snapchat = json['snapchat'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    about = json['about'] != null ? new Name.fromJson(json['about']) : null;
    terms = json['terms'] != null ? new Name.fromJson(json['terms']) : null;
    privacy =
        json['privacy'] != null ? new Name.fromJson(json['privacy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = phoneNumber;
    data['whatsapp'] = whatsapp;
    data['instagram'] = instagram;
    data['snapchat'] = snapchat;
    data['twitter'] = twitter;
    data['facebook'] = facebook;
    if (about != null) {
      data['about'] = about.toJson();
    }
    if (terms != null) {
      data['terms'] = terms.toJson();
    }
    if (privacy != null) {
      data['privacy'] = privacy.toJson();
    }
    return data;
  }
}
