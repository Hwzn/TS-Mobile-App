class ReviewModel {
  num attendance;
  num grades;
  num performance;
  num understanding;

  ReviewModel(
      {this.attendance, this.grades, this.performance, this.understanding});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    attendance = json['attendance'];
    grades = json['grades'];
    performance = json['performance'];
    understanding = json['understanding'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendance'] = this.attendance;
    data['grades'] = this.grades;
    data['performance'] = this.performance;
    data['understanding'] = this.understanding;
    return data;
  }
}
