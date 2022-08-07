import 'dart:io';

import 'package:ts_academy/core/models/basic_data.dart';
import 'package:ts_academy/core/models/review.dart';
import 'package:ts_academy/core/models/student_model.dart';
import 'package:ts_academy/core/models/subject.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/pricing.service.dart';

class Course {
  String sId;
  List<Attachements> attachements;
  List<String> days;
  num hour;
  List<Review> reviews;
  String type;
  String status;
  Name cover;
  Name name;
  Name info;
  num rate;
  int startDate;
  Name description;
  Grade grade;
  Subject subject;
  User teacher;
  List excercices;
  Stage stage;
  List<Course> related;
  int enrolled;
  num price;
  int createdAt;

  Course(
      {this.sId,
      this.attachements,
      this.days,
      this.hour,
      this.reviews,
      this.type,
      this.status,
      this.rate = 5,
      this.cover,
      this.name,
      this.info,
      this.startDate,
      this.description,
      this.grade,
      this.subject,
      this.teacher,
      this.createdAt,
      this.excercices,
      this.stage,
      this.related,
      this.price = 0,
      this.enrolled});

  Course.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['attachements'] != null) {
      attachements = <Attachements>[];
      json['attachements'].forEach((v) {
        attachements.add(Attachements.fromJson(v));
      });
    }
    if (json['days'] != null) {
      days = <String>[];
      json['days'].forEach((v) {
        days.add(v);
      });
    }
    if (json['reviews'] != null) {
      reviews = <Review>[];
      json['reviews'].forEach((v) {
        reviews.add(Review.fromJson(v));
      });
      rate = reviews.isNotEmpty
          ? reviews.fold(0,
                  (previousValue, element) => previousValue + element.stars) /
              reviews.length
          : 5;
    } else {
      rate = 5;
    }
    hour = json['hour'];
    type = json['type'];
    status = json['status'];
    createdAt = json['createdAt'];
    price = json['price'];
    cover = json['cover'] != null ? Name.fromJson(json['cover']) : null;
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    info = json['info'] != null ? Name.fromJson(json['info']) : null;
    startDate = json['startDate'];
    description =
        json['description'] != null ? Name.fromJson(json['description']) : null;
    grade = json['grade'] != null ? Grade.fromJson(json['grade']) : null;
    subject =
        json['subject'] != null ? Subject.fromJson(json['subject']) : null;
    teacher = json['teacher'] != null ? User.fromJson(json['teacher']) : null;
    if (json['excercices'] != null) {
      excercices = <dynamic>[];
      json['excercices'].forEach((v) {
        excercices.add(v);
      });
    }
    stage = json['stage'] != null ? Stage.fromJson(json['stage']) : null;
    if (json['related'] != null) {
      related = <Course>[];
      json['related'].forEach((v) {
        related.add(Course.fromJson(v));
      });
    }
    enrolled = json['enrolled'];
  }

  Course.fromMinifiedCourse(MinifiedCourse minified) {
    sId = minified.sId;
    attachements = [];
    days = [];
    reviews = minified.reviews;
    type = minified.type;
    status = minified.status;
    cover = minified.cover;
    name = minified.name;
    info = minified.info;
    rate = minified.rate;
    startDate = minified.startDate;
    description = minified.description;
    grade = minified.grade;
    subject = minified.subject;
    teacher = minified.teacher;
    excercices = [];
    stage = minified.stage;
    price = minified.price;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (attachements != null) {
      data['attachements'] = attachements.map((v) => v.toJson()).toList();
    }
    if (days != null) {
      data['days'] = days.map((v) => v).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews.map((v) => v.toJson()).toList();
    }
    data['hour'] = hour;
    data['type'] = type;
    data['rate'] = rate;
    data['status'] = status;
    if (cover != null) {
      data['cover'] = cover.toJson();
    }
    if (name != null) {
      data['name'] = name.toJson();
    }
    if (info != null) {
      data['info'] = info.toJson();
    }
    data['startDate'] = startDate;
    if (description != null) {
      data['description'] = description.toJson();
    }
    if (grade != null) {
      data['grade'] = grade.toJson();
    }
    if (subject != null) {
      data['subject'] = subject.toJson();
    }
    if (teacher != null) {
      data['teacher'] = teacher.toJson();
    }
    if (excercices != null) {
      data['excercices'] = excercices.map((v) => v).toList();
    }
    if (stage != null) {
      data['stage'] = stage.toJson();
    }
    if (related != null) {
      data['related'] = related.map((v) => v.toJson()).toList();
    }
    data['enrolled'] = enrolled;
    return data;
  }

  num get basePrice => type == 'session'
      ? (locator<PricingService>().session?.rawPrice ?? 0)
      : type == 'tutorial'
          ? (locator<PricingService>().tutorial?.rawPrice ?? 0)
          : price;
  String get typedPrice => type == 'session'
      ? (locator<PricingService>().session?.price ??
          '${Platform.isAndroid ? locator<PricingService>().pricing?.sessionAndroidPrice : locator<PricingService>().pricing?.sessionApplePrice} SR')
      : type == 'tutorial'
          ? (locator<PricingService>().tutorial?.price ??
              '${Platform.isAndroid ? locator<PricingService>().pricing?.tutorialAndroidPrice : locator<PricingService>().pricing?.tutorialAppleId} SR')
          : '$price SR';
}

class Attachements {
  String sId;
  int length;
  int chunkSize;
  String uploadDate;
  String filename;
  String md5;
  String contentType;

  Attachements(
      {this.sId,
      this.length,
      this.chunkSize,
      this.uploadDate,
      this.filename,
      this.md5,
      this.contentType});

  Attachements.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    length = json['length'];
    chunkSize = json['chunkSize'];

    uploadDate = json['uploadDate'];
    filename = json['filename'];
    md5 = json['md5'];
    contentType = json['contentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['length'] = length;
    data['chunkSize'] = chunkSize;
    data['uploadDate'] = uploadDate;
    data['filename'] = filename;
    data['md5'] = md5;
    data['contentType'] = contentType;
    return data;
  }
}

class Content {
  String chapter;
  List<Lessons> lessons;
  String oId;

  Content({this.chapter, this.lessons, this.oId});

  Content.fromJson(Map<String, dynamic> json) {
    chapter = json['chapter'];
    if (json['lessons'] != null) {
      lessons = List<Lessons>();
      json['lessons'].forEach((v) {
        lessons.add(Lessons.fromJson(v));
      });
    }
    oId = json['OId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['chapter'] = chapter;
    if (lessons != null) {
      data['lessons'] = lessons.map((v) => v.toJson()).toList();
    }
    data['OId'] = oId;
    return data;
  }
}

class Lessons {
  String name;
  String type;
  Attachement attachement;
  String oId;
  int uId;
  bool isDone;
  List<Exersices> exersices;

  Lessons(
      {this.name,
      this.type,
      this.attachement,
      this.oId,
      this.uId,
      this.isDone,
      this.exersices});

  Lessons.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    attachement = json['attachement'] != null
        ? Attachement.fromJson(json['attachement'])
        : null;
    oId = json['OId'];
    uId = json['uId'];
    isDone = json['isDone'];
    if (json['exersices'] != null) {
      exersices = List<Exersices>();
      json['exersices'].forEach((v) {
        exersices.add(Exersices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['type'] = type;
    if (attachement != null) {
      data['attachement'] = attachement.toJson();
    }
    data['OId'] = oId;
    data['uId'] = uId;
    data['isDone'] = isDone;
    if (exersices != null) {
      data['exersices'] = exersices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachement {
  String id;
  String path;
  String name;
  String mimetype;

  Attachement({this.id, this.path, this.name, this.mimetype});

  Attachement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    name = json['name'];
    mimetype = json['mimetype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['path'] = path;
    data['name'] = name;
    data['mimetype'] = mimetype;
    return data;
  }
}

class Exersices {
  String oId;
  User user;
  String link;

  Exersices({this.oId, this.user, this.link});

  Exersices.fromJson(Map<String, dynamic> json) {
    oId = json['oId'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['oId'] = oId;
    if (user != null) {
      data['user'] = user.toJson();
    }
    if (link != null) {
      data['link'] = link;
    }
    return data;
  }
}

class MinifiedCourse {
  String sId;
  String type;
  String status;
  Name cover;
  int createdAt;
  Name name;
  Name info;
  int startDate;
  Name description;
  Grade grade;
  Subject subject;
  User teacher;
  Stage stage;
  num price;
  num rate;
  List<Review> reviews;

  MinifiedCourse(
      {this.sId,
      this.type,
      this.status,
      this.cover,
      this.name,
      this.info,
      this.startDate,
      this.description,
      this.grade,
      this.subject,
      this.createdAt,
      this.teacher,
      this.stage,
      this.rate = 5,
      this.reviews,
      this.price = 0});

  MinifiedCourse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    status = json['status'];

    if (json['reviews'] != null) {
      reviews = <Review>[];
      json['reviews'].forEach((v) {
        reviews.add(Review.fromJson(v));
      });
      rate = reviews.isNotEmpty
          ? reviews.fold(0,
                  (previousValue, element) => previousValue + element.stars) /
              reviews.length
          : 5;
    } else {
      rate = 5;
    }
    price = json['price'];
    cover = json['cover'] != null ? Name.fromJson(json['cover']) : null;
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    info = json['info'] != null ? Name.fromJson(json['info']) : null;
    startDate = json['startDate'];
    description =
        json['description'] != null ? Name.fromJson(json['description']) : null;
    grade = json['grade'] != null ? Grade.fromJson(json['grade']) : null;
    subject =
        json['subject'] != null ? Subject.fromJson(json['subject']) : null;
    teacher = json['teacher'] != null ? User.fromJson(json['teacher']) : null;
    stage = json['stage'] != null ? Stage.fromJson(json['stage']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['type'] = type;
    data['status'] = status;
    data['price'] = price;
    data['rate'] = rate;
    if (cover != null) {
      data['cover'] = cover.toJson();
    }
    if (name != null) {
      data['name'] = name.toJson();
    }
    if (info != null) {
      data['info'] = info.toJson();
    }
    data['startDate'] = startDate;
    if (description != null) {
      data['description'] = description.toJson();
    }
    if (grade != null) {
      data['grade'] = grade.toJson();
    }
    if (subject != null) {
      data['subject'] = subject.toJson();
    }
    if (teacher != null) {
      data['teacher'] = teacher.toJson();
    }
    if (stage != null) {
      data['stage'] = stage.toJson();
    }
    return data;
  }
}
