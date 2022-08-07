class Pricing {
  String sessionAndroidId;
  num sessionAndroidPrice;
  String sessionAppleId;
  num sessionApplePrice;
  num sessionWebPrice;
  String tutorialAndroidId;
  num tutorialAndroidPrice;
  String tutorialAppleId;
  num tutorialApplePrice;
  num tutorialWebPrice;

  Pricing(
      {this.sessionAndroidId,
      this.sessionAndroidPrice,
      this.sessionAppleId,
      this.sessionApplePrice,
      this.sessionWebPrice,
      this.tutorialAndroidId,
      this.tutorialAndroidPrice,
      this.tutorialAppleId,
      this.tutorialApplePrice,
      this.tutorialWebPrice});

  Pricing.fromJson(Map<String, dynamic> json) {
    sessionAndroidId = json['sessionAndroidId'];
    sessionAndroidPrice = json['sessionAndroidPrice'];
    sessionAppleId = json['sessionAppleId'];
    sessionApplePrice = json['sessionApplePrice'];
    sessionWebPrice = json['sessionWebPrice'];
    tutorialAndroidId = json['tutorialAndroidId'];
    tutorialAndroidPrice = json['tutorialAndroidPrice'];
    tutorialAppleId = json['tutorialAppleId'];
    tutorialApplePrice = json['tutorialApplePrice'];
    tutorialWebPrice = json['tutorialWebPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sessionAndroidId'] = this.sessionAndroidId;
    data['sessionAndroidPrice'] = this.sessionAndroidPrice;
    data['sessionAppleId'] = this.sessionAppleId;
    data['sessionApplePrice'] = this.sessionApplePrice;
    data['sessionWebPrice'] = this.sessionWebPrice;
    data['tutorialAndroidId'] = this.tutorialAndroidId;
    data['tutorialAndroidPrice'] = this.tutorialAndroidPrice;
    data['tutorialAppleId'] = this.tutorialAppleId;
    data['tutorialApplePrice'] = this.tutorialApplePrice;
    data['tutorialWebPrice'] = this.tutorialWebPrice;
    return data;
  }
}
