import 'package:cloud_firestore/cloud_firestore.dart';

class SingleChatModel {
  String chatId;
  FieldValue createdAt;
  String fullname1;
  String fullname2;
  String objectId;
  String pic1;
  String pic2;
  FieldValue updatedAt;
  String userId1;
  String userId2;

  SingleChatModel(
      {this.chatId,
      this.createdAt,
      this.fullname1,
      this.fullname2,
      this.objectId,
      this.pic1,
      this.pic2,
      this.updatedAt,
      this.userId1,
      this.userId2});

  SingleChatModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    createdAt = json['createdAt'];
    fullname1 = json['fullname1'];
    fullname2 = json['fullname2'];
    objectId = json['objectId'];
    pic1 = json['pic1'];
    pic2 = json['pic2'];
    updatedAt = json['updatedAt'];
    userId1 = json['userId1'];
    userId2 = json['userId2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatId'] = this.chatId;
    data['createdAt'] = this.createdAt;
    data['fullname1'] = this.fullname1;
    data['fullname2'] = this.fullname2;
    data['objectId'] = this.objectId;
    data['pic1'] = this.pic1;
    data['pic2'] = this.pic2;
    data['updatedAt'] = this.updatedAt;
    data['userId1'] = this.userId1;
    data['userId2'] = this.userId2;
    return data;
  }

  SingleChatModel.fromUser({
    String chatId,
    String userId1,
    String name1,
    String pic1,
    String userId2,
    String name2,
    String pic2,
  }) {
    createdAt = FieldValue.serverTimestamp();
    fullname1 = name1;
    fullname2 = name2;
    objectId = chatId;
    this.pic1 = pic1;
    this.pic2 = pic2;
    updatedAt = FieldValue.serverTimestamp();
    this.chatId = chatId;
    this.userId1 = userId1;
    this.userId2 = userId2;
  }
}
