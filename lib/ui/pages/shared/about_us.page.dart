import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ts_academy/core/models/basic_data.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/styles/text_styles.dart';

class StaticPage extends StatelessWidget {
  final Name content;
  final String title;
  const StaticPage({Key key, this.content, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          locale.get(title),
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          content.localized(context),
          style: TextStyles.subHeaderStyle
              .copyWith(letterSpacing: 1.15, height: 1.5),
        ),
      )),
    );
  }
}
