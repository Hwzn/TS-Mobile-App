import 'package:ts_academy/core/models/user_model.dart';

class Review {
  String comment;
  int stars;
  String oId;
  User user;
  int time;

  Review({this.comment, this.stars, this.oId, this.user, this.time});

  Review.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    stars = json['stars'];
    oId = json['OId'];
    if (json['user'] is String) {
      user = User.fromString(json['user']);
    } else {
      user = json['user'] != null ? User.fromJson(json['user']) : null;
    }
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['stars'] = this.stars;
    data['OId'] = this.oId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['time'] = this.time;
    return data;
  }
}

// class Reviews {
//   String comment;
//   int stars;
//   String oId;
//   String user;
//   int time;

//   Reviews({this.comment, this.stars, this.oId, this.user, this.time});

//   Reviews.fromJson(Map<String, dynamic> json) {
//     comment = json['comment'];
//     stars = json['stars'];
//     oId = json['OId'];
//     user = json['user'];
//     time = json['time'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['comment'] = this.comment;
//     data['stars'] = this.stars;
//     data['OId'] = this.oId;
//     data['user'] = this.user;
//     data['time'] = this.time;
//     return data;
//   }
// }
