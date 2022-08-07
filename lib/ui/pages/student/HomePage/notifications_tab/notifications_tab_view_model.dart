import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:ts_academy/core/models/notice.model.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class NotificationModel extends BaseNotifier {
  final BuildContext context;
  final AppLocalizations locale;

  NotificationModel(this.context, this.locale) {
    getMyNotifications();
  }
  List<Notice> notices = [];

  Future<void> getMyNotifications() async {
    setBusy();
    var res = await api.getMyNotifications(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      // Logger().wtf(data);
      notices = data.map<Notice>((item) => Notice.fromJson(item)).toList();
      setIdle();
    });
  }
}
