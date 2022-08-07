import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ts_academy/core/models/notice.model.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';

import 'chat_message_model.dart';
import 'single_chat_model.dart';

class ChatService {
  static String chatuserid;

  // Collection reference
  static final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('Message');
  static final CollectionReference personCollection =
      FirebaseFirestore.instance.collection('Person');
  static final CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('Chats');
  // static final CollectionReference coursesCollection =
  //     FirebaseFirestore.instance.collection('Courses');

  //#TODO: user1 for doctor
  //#TODO: user2 for user

  static createNewUser(User user) async {
    return await personCollection.doc(user.sId).set(user.toJson());
  }

  static updateUserChatTime(String chatID) async {
    await chatsCollection
        ?.doc(chatID)
        ?.update({'updatedAt': DateTime.now().millisecondsSinceEpoch});
  }

  // get last chats
  static Stream<QuerySnapshot> getUserChats({bool isDoctor = false}) {
    final String whereKey = isDoctor ? 'userId1' : 'userId2';
    return chatsCollection
        .where(whereKey, isEqualTo: chatuserid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  // static Stream<QuerySnapshot> getCourseComments(
  //     String courseId, String lessonId) {
  //   return coursesCollection
  //       .doc(courseId)
  //       .collection('Lessons')
  //       .doc(lessonId)
  //       .collection('Comments')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots();
  // }

  static StreamSubscription<QuerySnapshot> getChatMessagesList(
      {@required String chatId, Function(QuerySnapshot) onData}) {
    return messageCollection
        .where('chatId', isEqualTo: chatId)
        .orderBy("createdAt")
        .snapshots(includeMetadataChanges: true)
        .listen((data) => onData(data));
  }

  static void createChatMessage(String chatId,
      {@required String text, @required String userName}) async {
    final docRef = messageCollection.doc();

    final chatMessage = ChatMessageModel.fromText(
        chatId: chatId,
        objectId: docRef.id,
        text: text,
        userId: chatuserid,
        userFullname: userName);

    await docRef.set(chatMessage.toJson());
  }

  static Future<DocumentReference> createChatMedia({
    @required String chatId,
    @required String userFullname,
    @required String fileType,
    @required String imageUrl,
  }) async {
    final dr = messageCollection.doc();

    if (fileType == "image") {
      final singleChat = ChatMessageModel.fromImage(
          chatId: chatId,
          userId: chatuserid,
          objectId: dr.id,
          userFullname: userFullname,
          imageUrl: imageUrl);
      await dr.set(singleChat.toJson());
    }
    return dr;
  }

  // for creating single chat to appear in the chatting list
  static void createChat({
    @required String name1,
    @required String userId1,
    @required String pic1,
    @required String name2,
    @required String userId2,
    @required String pic2,
  }) async {
    final String chatId = userId1 + userId2;
    final docRef = chatsCollection.doc(chatId);

    final singleChat = SingleChatModel.fromUser(
      chatId: chatId,
      userId1: userId1,
      name1: name1,
      pic1: pic1,
      userId2: userId2,
      name2: name2,
      pic2: pic2,
    );

    await docRef.set(singleChat.toJson());
  }

  static void deleteMessage(id) {
    messageCollection.doc(id).delete();
  }

  static Future<String> getUserToken({String userID}) {
    final docRef = personCollection.doc();
  }
}
