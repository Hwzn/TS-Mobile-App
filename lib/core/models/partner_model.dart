class Partner {
  String sId;
  String logo;
  String name;

  Partner({
    this.sId,
    this.logo,
    this.name,
  });

  Partner.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    logo = json['logo'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['logo'] = this.logo;
    data['name'] = this.name;
    return data;
  }
}
