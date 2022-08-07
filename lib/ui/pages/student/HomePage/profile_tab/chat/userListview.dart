import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/chat/usersListviewModel.dart';

class ListUserPage extends StatefulWidget {
  @override
  _ListUserPageState createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsersListViewModel>(
        create: (context) => UsersListViewModel(),
        child: Consumer<UsersListViewModel>(builder: (context, model, __) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Messages",
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
            body: Container(),
          );
        }));
  }
}
