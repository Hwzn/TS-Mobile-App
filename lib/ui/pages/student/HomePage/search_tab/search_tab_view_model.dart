import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_academy/core/models/search_model.dart';
import 'package:ts_academy/core/models/subject.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';
import 'package:ts_academy/ui/routes/ui.dart';

class SearchTabViewModel extends BaseNotifier {
  BuildContext context;
  SearchTabViewModel({this.context}) {
    getSubject(context);
  }
  bool haveSearchResult = false;
  SearchModel searchResult;

  void search(String search) async {
    Map<String, dynamic> query = {"search": search, "page": 1, "limit": 10};
    setBusy();
    var res = await api.getSearch(context, query);
    res.fold((error) {
      UI.toast(error.message);
      setError();
    }, (data) {
      searchResult = SearchModel.fromJson(data);
      haveSearchResult = true;
      setIdle();
    });
  }

  RefreshController refreshController = RefreshController();

  List<Subject> subjects = [];

  void getSubject(context) async {
    setBusy();
    var res = await api.getAllSubjects(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      subjects = data.map<Subject>((item) => Subject.fromJson(item)).toList();
      setIdle();
    });
  }


}
