import 'package:flutter/material.dart';

import '../services/api/http_api.dart';
import 'provider_setup.dart';

/*
 * add mounted option to stop calling build methods after disposal
 */
enum NotifierState { busy, idle, error }

class BaseNotifier extends ChangeNotifier {
  NotifierState _state = NotifierState.idle;
  bool _mounted = true;
  final HttpApi api = locator<HttpApi>();
  // final AuthenticationService auth = locator<AuthenticationService>();

  BaseNotifier({NotifierState state}) {
    if (state != null) _state = state;
  }

  bool get mounted => _mounted;
  NotifierState get state => _state;
  bool get idle => _state == NotifierState.idle;
  bool get busy => _state == NotifierState.busy;
  bool get hasError => _state == NotifierState.error;

  setBusy() => setState(state: NotifierState.busy);
  setIdle() => setState(state: NotifierState.idle);
  setError() => setState(state: NotifierState.error);

  setState({NotifierState state, bool notifyListener = true}) {
    print("set state is called");
    if (state != null) _state = state;
    if (mounted && notifyListener) notifyListeners();
    // notifyListeners();
  }

  @override
  dispose() {
    _mounted = false;
    debugPrint(
        '*************** \n\n -- ${this.runtimeType} Provider Has Disposed -- \n\n***************');
    super.dispose();
  }
}
