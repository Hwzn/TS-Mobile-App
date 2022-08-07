import 'package:ts_academy/core/models/user_model.dart';

class Notice {
  String sId;
  String title;
  String body;
  String entityType;
  String entityId;
  int valueDate;
  User user;

  Notice(
      {this.sId,
      this.title,
      this.body,
      this.entityType,
      this.entityId,
      this.valueDate});

  Notice.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    body = json['body'];
    entityType = json['entityType'];
    entityId = json['entityId'];
    valueDate = json['valueDate'] != null
        ? json['valueDate']
        : DateTime.now().millisecondsSinceEpoch;
    user = json['user'] != null
        ? (json['user'] is String
            ? new User.fromString(json['user'])
            : new User.fromJson(json['user']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['entityType'] = this.entityType;
    data['entityId'] = this.entityId;
    data['valueDate'] = this.valueDate;
      if (this.user != null) {
      data['user'] = this.user.toJson();
    }

    return data;
  }
}
