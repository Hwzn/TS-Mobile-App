import 'package:ts_academy/core/models/user_model.dart';

import 'course.dart';

class CheckoutResponse {
  int discount;
  String paymentStatus;
  int price;
  int valueDate;
  String sId;
  User user;
  Course course;
  int priceBeforeDiscount;
  int priceAfterDiscount;
  int iV;
  PaymentResult paymentResult;

  CheckoutResponse(
      {this.discount,
      this.paymentStatus,
      this.price,
      this.valueDate,
      this.sId,
      this.user,
      this.course,
      this.priceBeforeDiscount,
      this.priceAfterDiscount,
      this.iV,
      this.paymentResult});

  CheckoutResponse.fromJson(Map<String, dynamic> json) {
    discount = json['discount'];
    paymentStatus = json['paymentStatus'];
    price = json['price'];
    valueDate = json['valueDate'];
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    course =
        json['course'] != null ? Course.fromJson(json['course']) : null;
    priceBeforeDiscount = json['priceBeforeDiscount'];
    priceAfterDiscount = json['priceAfterDiscount'];
    iV = json['__v'];
    paymentResult = json['paymentResult'] != null
        ? PaymentResult.fromJson(json['paymentResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['discount'] = this.discount;
    data['paymentStatus'] = this.paymentStatus;
    data['price'] = this.price;
    data['valueDate'] = this.valueDate;
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.course != null) {
      data['course'] = this.course.toJson();
    }
    data['priceBeforeDiscount'] = this.priceBeforeDiscount;
    data['priceAfterDiscount'] = this.priceAfterDiscount;
    data['__v'] = this.iV;
    if (this.paymentResult != null) {
      data['paymentResult'] = this.paymentResult.toJson();
    }
    return data;
  }
}

class PaymentResult {
  String id;
  String paymentType;
  String paymentBrand;
  String amount;
  String currency;
  String descriptor;
  String merchantTransactionId;
  Result result;
  ResultDetails resultDetails;
  Card card;
  Customer customer;
  Redirect redirect;
  Risk risk;
  String buildNumber;
  String timestamp;
  String ndc;

  PaymentResult(
      {this.id,
      this.paymentType,
      this.paymentBrand,
      this.amount,
      this.currency,
      this.descriptor,
      this.merchantTransactionId,
      this.result,
      this.resultDetails,
      this.card,
      this.customer,
      this.redirect,
      this.risk,
      this.buildNumber,
      this.timestamp,
      this.ndc});

  PaymentResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentType = json['paymentType'];
    paymentBrand = json['paymentBrand'];
    amount = json['amount'];
    currency = json['currency'];
    descriptor = json['descriptor'];
    merchantTransactionId = json['merchantTransactionId'];
    result =
        json['result'] != null ? Result.fromJson(json['result']) : null;
    resultDetails = json['resultDetails'] != null
        ? ResultDetails.fromJson(json['resultDetails'])
        : null;
    card = json['card'] != null ? Card.fromJson(json['card']) : null;
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    redirect = json['redirect'] != null
        ? Redirect.fromJson(json['redirect'])
        : null;
    risk = json['risk'] != null ? Risk.fromJson(json['risk']) : null;
    buildNumber = json['buildNumber'];
    timestamp = json['timestamp'];
    ndc = json['ndc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['paymentType'] = this.paymentType;
    data['paymentBrand'] = this.paymentBrand;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['descriptor'] = this.descriptor;
    data['merchantTransactionId'] = this.merchantTransactionId;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    if (this.resultDetails != null) {
      data['resultDetails'] = this.resultDetails.toJson();
    }
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    if (this.redirect != null) {
      data['redirect'] = this.redirect.toJson();
    }
    if (this.risk != null) {
      data['risk'] = this.risk.toJson();
    }
    data['buildNumber'] = this.buildNumber;
    data['timestamp'] = this.timestamp;
    data['ndc'] = this.ndc;
    return data;
  }
}

class Result {
  String code;
  String description;

  Result({this.code, this.description});

  Result.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['description'] = this.description;
    return data;
  }
}

class ResultDetails {
  String extendedDescription;
  String acquirerResponse;

  ResultDetails({this.extendedDescription, this.acquirerResponse});

  ResultDetails.fromJson(Map<String, dynamic> json) {
    extendedDescription = json['ExtendedDescription'];
    acquirerResponse = json['AcquirerResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ExtendedDescription'] = this.extendedDescription;
    data['AcquirerResponse'] = this.acquirerResponse;
    return data;
  }
}

class Card {
  String bin;
  String last4Digits;
  String holder;
  String expiryMonth;
  String expiryYear;

  Card(
      {this.bin,
      this.last4Digits,
      this.holder,
      this.expiryMonth,
      this.expiryYear});

  Card.fromJson(Map<String, dynamic> json) {
    bin = json['bin'];
    last4Digits = json['last4Digits'];
    holder = json['holder'];
    expiryMonth = json['expiryMonth'];
    expiryYear = json['expiryYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['bin'] = this.bin;
    data['last4Digits'] = this.last4Digits;
    data['holder'] = this.holder;
    data['expiryMonth'] = this.expiryMonth;
    data['expiryYear'] = this.expiryYear;
    return data;
  }
}

class Customer {
  String email;

  Customer({this.email});

  Customer.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}

class Redirect {
  String url;
  List<Parameters> parameters;

  Redirect({this.url, this.parameters});

  Redirect.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    if (json['parameters'] != null) {
      parameters = <Parameters>[];
      json['parameters'].forEach((v) {
        parameters.add(Parameters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = this.url;
    if (this.parameters != null) {
      data['parameters'] = this.parameters.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parameters {
  String name;
  String value;

  Parameters({this.name, this.value});

  Parameters.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class Risk {
  String score;

  Risk({this.score});

  Risk.fromJson(Map<String, dynamic> json) {
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['score'] = this.score;
    return data;
  }
}
