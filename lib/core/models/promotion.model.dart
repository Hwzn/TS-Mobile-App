class Promotion {
  String sId;
  String code;
  int fromDate;
  int toDate;
  bool useOnce;
  dynamic discountPercent;

  Promotion(
      {this.sId,
      this.code,
      this.fromDate,
      this.toDate,
      this.useOnce,
      this.discountPercent});

  Promotion.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    code = json['code'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    useOnce = json['useOnce'];
    discountPercent = json['discountPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['code'] = this.code;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['useOnce'] = this.useOnce;
    data['discountPercent'] = this.discountPercent;
    return data;
  }
}
