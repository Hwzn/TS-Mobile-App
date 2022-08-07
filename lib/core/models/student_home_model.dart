import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/models/filter_model.dart';
import 'package:ts_academy/core/models/partner_model.dart';
import 'package:ts_academy/core/models/subject.dart';
import 'package:ts_academy/core/models/user_model.dart';

import 'banner.dart';

class StudentHome {
  List<Banners> banners;
  List<Partner> partners;
  List<MinifiedCourse> featuresCourses;
  List<MinifiedCourse> addedRecently;
  List<MinifiedCourse> startSoon;
  List<Subject> subjects;
  List<Instructor> topInstructors;

  StudentHome(
      {this.banners,
      this.partners,
      this.featuresCourses,
      this.addedRecently,
      this.startSoon,
      this.subjects,
      this.topInstructors});

  StudentHome.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners.add(Banners.fromJson(v));
      });
    }
    if (json['partners'] != null) {
      partners = <Partner>[];
      json['partners'].forEach((v) {
        partners.add(Partner.fromJson(v));
      });
    }
    if (json['featuresCourses'] != null) {
      featuresCourses = <MinifiedCourse>[];
      json['featuresCourses'].forEach((v) {
        featuresCourses.add(MinifiedCourse.fromJson(v));
      });
    }
    if (json['addedRecently'] != null) {
      addedRecently = <MinifiedCourse>[];
      json['addedRecently'].forEach((v) {
        addedRecently.add(MinifiedCourse.fromJson(v));
      });
    }
    if (json['startSoon'] != null) {
      startSoon = <MinifiedCourse>[];
      json['startSoon'].forEach((v) {
        startSoon.add(MinifiedCourse.fromJson(v));
      });
    }
    if (json['subjects'] != null) {
      subjects = <Subject>[];
      json['subjects'].forEach((v) {
        subjects.add(Subject.fromJson(v));
      });
    }
    if (json['topInstructors'] != null) {
      topInstructors = <Instructor>[];
      json['topInstructors'].forEach((v) {
        topInstructors.add(Instructor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (banners != null) {
      data['banners'] = banners.map((v) => v.toJson()).toList();
    }
    if (partners != null) {
      data['partners'] = partners.map((v) => v.toJson()).toList();
    }
    if (featuresCourses != null) {
      data['featuresCourses'] = featuresCourses.map((v) => v.toJson()).toList();
    }
    if (addedRecently != null) {
      data['addedRecently'] = addedRecently.map((v) => v.toJson()).toList();
    }
    if (startSoon != null) {
      data['startSoon'] = startSoon.map((v) => v.toJson()).toList();
    }
    if (subjects != null) {
      data['subjects'] = subjects.map((v) => v.toJson()).toList();
    }
    if (topInstructors != null) {
      data['topInstructors'] = topInstructors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
