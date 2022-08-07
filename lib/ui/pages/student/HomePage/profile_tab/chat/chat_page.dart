import 'dart:async';
import 'dart:io' as Io;
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_academy/core/models/notice.model.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_service.dart';

class ChatPage extends StatelessWidget {
  final String userName;
  final String userId;
  final String userAvatar;

  ChatPage({this.userId, this.userName, this.userAvatar});
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<ChatPageModel>(
      create: (context) => ChatPageModel(userId: userId),
      child: Consumer<ChatPageModel>(builder: (context, model, __) {
        return Scaffold(
            backgroundColor: AppColors.primaryBackground,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                userName ?? locale.get("Messages"),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 20),
              ),
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: SizeConfig.heightMultiplier * 100,
                width: SizeConfig.widthMultiplier * 100,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(child: buildChatsList(model)),
                    buildChatActions(context, model),
                  ],
                ),
              ),
            ));
      }),
    );
  }

  Widget buildChatActions(BuildContext context, ChatPageModel model) {
    final locale = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  readOnly: model.path != null,
                  onSubmitted: (string) {
                    !(model.path == null &&
                            model.messageController.text.isEmpty)
                        ? model.path == null
                            ? model.sendMessage('text')
                            : model.sendMessage('image')
                        // ignore: unnecessary_statements
                        : null;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: model.path == null
                          ? locale.get('Type a message ...')
                          : locale.get('image uploaded'),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      contentPadding: EdgeInsets.all(8)),
                  controller: model.messageController,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                model.sendMessage('text');

                // ignore: unnecessary_statements
              },
              child: CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildChatsList(ChatPageModel model) {
    if (model.chatMessages != null && model.chatMessages.isNotEmpty) {
      return ListView.builder(
          shrinkWrap: true,
          reverse: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 5),
          itemCount: model.chatMessages.length,
          itemBuilder: (context, index) =>
              buildChatMessages(context, model, index));
    } else {
      return SizedBox();
    }
  }
}

Widget buildChatMessages(BuildContext context, ChatPageModel model, index) {
  // final objectId = model.chatMessages[index].get('objectId');
  final String msg = model.chatMessages[index].get('text');

  print(model.chatMessages[index].data());
  bool isSender = model.chatMessages[index].get('userId') !=
      locator<AuthenticationService>().user.sId;
  final locale = AppLocalizations.of(context);
  final updatedAt = model.chatMessages[index].get('updatedAt');
  // print(model.chatMessages[index].);
  print(model.chatMessages[index].get('userId'));
  print(locator<AuthenticationService>().user.sId);
  return InkWell(
    onLongPress: () async {
      if (model.chatMessages[index].get("userId") == ChatService.chatuserid) {
        final res = await UI.dialog(
          context: context,
          title: "Delete this message",
          msg: "Are you sure you want to delete this message?",
          accept: true,
          acceptMsg: "Delete",
          cancelMsg: "Cancel",
        );

        if (res != null && res) {
          // ChatService.deleteMessage(objectId);
          model.chatMessages = [];
          model.getChatMessages();
        }
      }
    },
    child: Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isSender
                      ? Color(0xffDA291C).withOpacity(0.2)
                      : Color(0xffF2F6F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 200,
                child: Column(
                  children: [
                    Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Align(
                              alignment: locale.locale.languageCode == 'ar'
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Text(
                                msg ?? 'Message',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: isSender
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            buildChatTime(context, updatedAt),
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]),
  );
}

String buildChatTime(BuildContext context, int updatedAt) {
  final locale = AppLocalizations.of(context);

  if (updatedAt != null)
    return timeago.format(DateTime.fromMillisecondsSinceEpoch(updatedAt),
        locale: locale.locale.languageCode);
  else
    return '';
}

class ChatPageModel extends BaseNotifier {
  final String userId;
  final AppLocalizations locale;
  BuildContext context;
  TextEditingController messageController = TextEditingController();
  List<Message> msgs;
  List<Message> msgs2;

  List<DocumentSnapshot> chatMessages;
  StreamSubscription chatUpdate;

  ChatPageModel({
    NotifierState state,
    this.userId,
    this.locale,
  }) : super(state: state) {
    getChatMessages();
  }

  RefreshController _refreshController = RefreshController();

  bool uploading = false;
  String path;
  File choosedImage;
  String base64Image;

  uploadImage(ImageSource imageSource) async {
    final locale = AppLocalizations.of(context);
    final pickedFile = await ImagePicker().getImage(
        source: imageSource, maxHeight: 800, maxWidth: 800, imageQuality: 80);
    if (pickedFile != null) {
      choosedImage = Io.File(pickedFile.path);
      uploading = true;
      setState();
      var res = await api.uploadImage(context, image: Io.File(pickedFile.path));
      res.fold((error) => UI.toast(error.toString()), (data) async {
        path = data['path'];
      });
      uploading = false;
      setState();
    } else {
      UI.toast(locale.get('No image selected') ?? "No image selected");
    }
    return path;
  }

  void getChatMessages() async {
    final String userChatId =
        locator<AuthenticationService>().user.userType == "Teacher"
            ? locator<AuthenticationService>().user.sId + userId
            : userId + locator<AuthenticationService>().user.sId;
    final chatId = userChatId;
    chatUpdate = ChatService.getChatMessagesList(
        chatId: chatId,
        onData: (data) {
          if (data.docChanges.isNotEmpty) {
            try {
              data.docChanges.forEach((element) {
                if (chatMessages == null) {
                  chatMessages = [];
                  setState();
                }
                // for new message
                if (element.type == DocumentChangeType.added) {
                  chatMessages.insert(0, element.doc);
                  element.doc.data();
                  // if (element.doc.get('updatedAt') != null) {
                  //   final timeStamp =
                  //       (element.doc.get('updatedAt') as Timestamp)
                  //           .toDate()
                  //           .millisecondsSinceEpoch;
                  //   // Preference.setInt(chatId, timeStamp + 54259);
                  // }
                }
                // for updated
                else if (element.type == DocumentChangeType.modified) {
                  DocumentSnapshot doc = chatMessages.firstWhere(
                      (o) => o.id == element.doc.id,
                      orElse: () => null);
                  if (doc != null) {
                    final index = chatMessages.indexOf(doc);
                    chatMessages[index] = element.doc;
                    // if (element.doc.get('updatedAt') != null) {
                    //   final timeStamp =
                    //       (element.doc.get('updatedAt') as Timestamp).toDate();
                    //   // .millisecondsSinceEpoch;
                    //   // Preference.setInt(chatId, timeStamp + 54259);
                    // }
                  }
                }
                // for message removal
                else if (element.type == DocumentChangeType.removed) {
                  chatMessages.removeWhere(
                    (o) => o.id == element.doc.id,
                  );
                }
                setState();
              });
            } on Exception catch (e) {
              print(e);
            }
          } else if (chatMessages == null) {
            chatMessages = [];
            setState();
          }
        });
  }

  sendMessage(String type) async {
    final String userChatId =
        locator<AuthenticationService>().user.userType == "Teacher"
            ? locator<AuthenticationService>().user.sId + userId
            : userId + locator<AuthenticationService>().user.sId;
    final chatId = userChatId;
    try {
      final message = messageController.text;
      if (message != null && message.isNotEmpty) {
        ChatService.updateUserChatTime(chatId);
        ChatService.createChatMessage(
          chatId,
          text: message,
          userName: locator<AuthenticationService>().user.name,
        );
        Notice notification = new Notice();
        notification.title = locator<AuthenticationService>().user.name;
        notification.body = message;
        notification.entityType = 'Chat';
        notification.entityId = userId;
        notification.user = new User(sId: userId);

        await api.sendNotification(context, notification);
        messageController.clear();
      }
    } on Exception catch (e) {
      print(e);
    }

    // chatMessages = [];
    // getChatMessages();
  }

  @override
  void dispose() {
    chatUpdate?.cancel();
    super.dispose();
  }
}
