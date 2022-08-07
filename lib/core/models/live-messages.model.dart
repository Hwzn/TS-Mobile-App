class LiveMessage {
  LiveMessageUser user;
  String message;
  int time;

  LiveMessage({this.user, this.message, this.time});

  LiveMessage.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new LiveMessageUser.fromJson(json['user']) : null;
    message = json['message'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['message'] = this.message;
    data['time'] = this.time;
    return data;
  }
}

class LiveMessageUser {
  String name;
  String avatar;
  String sId;

  LiveMessageUser({this.name, this.avatar, this.sId});

  LiveMessageUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['_id'] = this.sId;
    return data;
  }
}
