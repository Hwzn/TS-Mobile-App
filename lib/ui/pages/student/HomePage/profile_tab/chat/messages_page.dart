import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'chat_page.dart';
import 'chat_service.dart';

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<MessagesPageModel>(
      create: (context) => MessagesPageModel(),
      child: Consumer<MessagesPageModel>(builder: (context, model, __) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                locale.get("Messages"),
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
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: buildChatsList(model));
      }),
    );
  }

  StreamProvider<QuerySnapshot> buildChatsList(MessagesPageModel model) {
    return StreamProvider<QuerySnapshot>(
      create: (con) => ChatService.getUserChats(isDoctor: false),
      updateShouldNotify: (snap1, snap2) => true,
      builder: (context, child) =>
          Consumer<QuerySnapshot>(builder: (context, snap, _) {
        final List<DocumentSnapshot> allSnaps = [];
        if (snap != null) {
          allSnaps..addAll(snap.docs);
        }
        return allSnaps.isEmpty
            ? buildEmptyChats(context, model)
            : ListView.separated(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) => Divider(),
                itemCount: allSnaps.length,
                itemBuilder: (context, index) =>
                    buildUserRow(context, model, allSnaps, index),
              );
      }),
    );
  }

  Widget buildEmptyChats(BuildContext context, model) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {},
            child:
                Icon(Icons.person_pin, color: AppColors.primaryColor, size: 50),
          ),
          Text(
            AppLocalizations.of(context).get('There is no chats yet'),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildUserRow(BuildContext context, MessagesPageModel model,
      List<DocumentSnapshot> snaps, int index) {
    final chatRow = snaps[index];
    final color =
        index % 2 == 0 ? Color(0xFFCC1C60).withOpacity(0.1) : Colors.white;

    print(snaps[index].data());
    bool isSameUser =
        locator<AuthenticationService>().user.sId == chatRow.get('userId1');
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
        ),
        child: Row(children: <Widget>[
          ClipRRect(
            child: CachedNetworkImage(
              imageUrl:
                  "https://mk0hiredbymatriolaxj.kinstacdn.com/wp-content/uploads/home-jobseeker.jpg",
              imageBuilder: (context, imageProvider) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Container(
            // width: 20,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSameUser
                      ? chatRow.get('fullname2')
                      : chatRow.get('fullname1'),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
      onTap: () {
        UI.push(
          context,
          ChatPage(
            userId:
                isSameUser ? chatRow.get('userId2') : chatRow.get('userId1'),
            userName: isSameUser
                ? chatRow.get('fullname2')
                : chatRow.get('fullname1'),
            userAvatar: isSameUser ? chatRow.get('pic2') : chatRow.get('pic1'),
          ),
        );
      },
    );
  }
}

class MessagesPageModel extends BaseNotifier {
  bool isVendor;
  MessagesPageModel({NotifierState state}) {
    isVendor = locator<AuthenticationService>().user.userType == 'Teacher';
  }
}
