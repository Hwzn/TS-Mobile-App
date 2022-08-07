import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatMessageModel {
  String chatId;
  FieldValue createdAt;
  bool isDeleted;
  String objectId;
  String text;
  String type;
  int updatedAt;
  String userFullname;
  String userId;
  String userInitials;
  int userPictureAt;

  ChatMessageModel({
    this.chatId,
    this.createdAt,
    this.isDeleted,
    this.objectId,
    this.text,
    this.type,
    this.updatedAt,
    this.userFullname,
    this.userId,
    this.userInitials,
    this.userPictureAt,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    createdAt = json['createdAt'];
    isDeleted = json['isDeleted'];

    objectId = json['objectId'];

    text = json['text'];
    type = json['type'];
    updatedAt = json['updatedAt'];
    userFullname = json['userFullname'];
    userId = json['userId'];
    userInitials = json['userInitials'];
    userPictureAt = json['userPictureAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatId'] = this.chatId;
    data['createdAt'] = this.createdAt;
    data['isDeleted'] = this.isDeleted;

    data['objectId'] = this.objectId;

    data['text'] = this.text;
    data['type'] = this.type;
    data['updatedAt'] = this.updatedAt;
    data['userFullname'] = this.userFullname;
    data['userId'] = this.userId;
    data['userInitials'] = this.userInitials;
    data['userPictureAt'] = this.userPictureAt;

    return data;
  }

  ChatMessageModel.fromText(
      {@required String chatId,
      @required String objectId,
      @required String text,
      @required String userId,
      @required String userFullname}) {
    this.chatId = chatId;
    createdAt = FieldValue.serverTimestamp();
    isDeleted = false;
    this.objectId = objectId;
    this.text = text;
    type = 'text';
    updatedAt = DateTime.now().millisecondsSinceEpoch;
    this.userFullname = userFullname;
    this.userId = userId;
    userInitials = userFullname?.split("")?.first ?? '';
    userPictureAt = 0;
  }

  ChatMessageModel.fromImage(
      {@required String chatId,
      @required String objectId,
      @required String userId,
      @required String userFullname,
      @required String imageUrl}) {
    this.chatId = chatId;
    createdAt = FieldValue.serverTimestamp();
    isDeleted = false;
    this.objectId = objectId;
    text = imageUrl;
    type = 'image';
    updatedAt = DateTime.now().millisecondsSinceEpoch;
    this.userFullname = userFullname;
    this.userId = userId;
    userInitials = userFullname?.split("")?.first ?? '';
    userPictureAt = 0;
  }
}
