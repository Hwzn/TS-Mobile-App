import 'dart:async';

// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/constants/keys.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/models/live-messages.model.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/MainHome/main_home_view.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/main_ui_teacher.page.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/start-live.model.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

import 'package:timeago/timeago.dart' as timeago;

class StreamSocket {
  final _socketResponse = StreamController<List<LiveMessage>>();

  void Function(List<LiveMessage>) get addResponse => _socketResponse.sink.add;

  Stream<List<LiveMessage>> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final Course course;
  final dynamic liveToken;

  /// Creates a call page with given channel name.
  const CallPage({Key key, this.liveToken, this.course}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  // RtcEngine _engine;

  String attenders = "0";
  StreamSocket streamSocket = StreamSocket();

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    // _engine.leaveChannel();
    // _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (Keys.AGORA_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    // await _initAgoraRtcEngine();
    // _addAgoraEventHandlers();
    // await _engine.enableWebSdkInteroperability(true);
    // VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    // configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    // await _engine.setVideoEncoderConfiguration(configuration);
    // await _engine.joinChannel(widget.liveToken, widget.course.sId, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    // _engine = await RtcEngine.create(Keys.AGORA_ID);
    // await _engine.enableVideo();
    // await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    // await _engine.setClientRole(
    //     locator<AuthenticationService>().user.userType == 'Teacher'
    //         ? ClientRole.Broadcaster
    //         : ClientRole.Audience);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    // _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
    //   setState(() {
    //     final info = 'onError: $code';
    //     _infoStrings.add(info);
    //   });
    // }, joinChannelSuccess: (channel, uid, elapsed) {
    //   setState(() {
    //     final info = 'onJoinChannel: $channel, uid: $uid';
    //     _infoStrings.add(info);
    //   });
    // }, leaveChannel: (stats) {
    //   setState(() {
    //     _infoStrings.add('onLeaveChannel');
    //     _users.clear();
    //   });
    // }, userJoined: (uid, elapsed) {
    //   setState(() {
    //     final info = 'userJoined: $uid';
    //     _infoStrings.add(info);
    //     _users.add(uid);
    //   });
    // }, userOffline: (uid, elapsed) {
    //   setState(() {
    //     final info = 'userOffline: $uid';
    //     _infoStrings.add(info);
    //     _users.remove(uid);
    //   });
    // }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
    //   setState(() {
    //     final info = 'firstRemoteVideo: $uid ${width}x $height';
    //     _infoStrings.add(info);
    //   });
    // }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (locator<AuthenticationService>().user.userType == 'Teacher') {
      // list.add(RtcLocalView.SurfaceView());
    } else
      // _users
      //     .forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
      return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    // if ()
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar(StartLiveModel model) {
    if (locator<AuthenticationService>().user.userType != 'Teacher')
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RawMaterialButton(
              onPressed: () => _onCallEnd(context, model),
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                size: 35.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: AppColors.red,
              padding: const EdgeInsets.all(15.0),
            ),
          ],
        ),
      );
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : AppColors.primaryColor,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? AppColors.primaryColor : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: AppColors.primaryColor,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context, model),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: AppColors.red,
            padding: const EdgeInsets.all(15.0),
          ),
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel(context) {
    final locale = AppLocalizations.of(context);

    return Container(
        padding: const EdgeInsets.only(top: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            child: Column(
              children: [
                Flexible(
                  child: StreamBuilder<List<LiveMessage>>(
                      stream: streamSocket.getResponse,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          // Logger().w(snapshot.data);
                          return Container(
                            child: Text(
                              locale.get('Send Your Comment Now'),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            List<LiveMessage> msgs = snapshot.data;
                            msgs.reversed;

                            final LiveMessage msg = msgs[index];
                            return Column(
                              children: [
                                Container(
                                  // color: AppColors.primaryBackground,
                                  decoration: new BoxDecoration(
                                      border: new Border.all(
                                          width: 1,
                                          color: Colors
                                              .transparent), //color is transparent so that it does not blend with the actual color specified
                                      borderRadius: const BorderRadius.all(
                                          const Radius.circular(30.0)),
                                      color: AppColors.primaryColor.withOpacity(
                                          0.5) // Specifies the background color and the opacity
                                      ),
                                  child: ListTile(
                                      leading: CircleAvatar(
                                        child: CachedNetworkImage(
                                            imageUrl: BaseFileUrl +
                                                (msg.user.avatar ?? ''),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Container(
                                                    width: SizeConfig
                                                            .widthMultiplier *
                                                        10,
                                                    height: SizeConfig
                                                            .heightMultiplier *
                                                        5,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Image.asset(
                                                        'assets/images/appicon.png'))),
                                      ),
                                      title: Text(msg.user.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                      trailing: Text(
                                        timeago.format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                msg.time),
                                            locale: locale.locale.languageCode,
                                            allowFromNow: true),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 8),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          msg.message,
                                          // maxLines: 5,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      )),
                                ),
                                SizedBox(height: 5)
                              ],
                            );
                            // return ;
                          },
                        );
                      }),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * .1,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: _commentController,
                            focusNode: _commentFocus,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                fillColor: Colors.grey.shade100,
                                hintText: locale.get('Send Comment'),
                                filled: true),
                          ),
                        ),
                        Expanded(
                            child: IconButton(
                          icon: Icon(Icons.send, color: AppColors.primaryColor),
                          onPressed: () {
                            if (_commentController.text != null) {}
                            _commentController.clear();
                          },
                        )),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  void _onCallEnd(BuildContext context, StartLiveModel model) {
    final locale = AppLocalizations.of(context);
    final userType = locator<AuthenticationService>().user.userType;
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          locale.get(userType == 'Teacher' ? "End live" : "Leave Live"),
          style: TextStyle(color: Color(0xffE41616)),
        ),
        content: Text(locale.get(userType == 'Teacher'
            ? "Are you sure to close the broadcast? This step cannot be reversed"
            : "are you sure you want to Leave broadcast")),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(locale.get("Cancel")),
          ),
          CupertinoDialogAction(
            isDefaultAction: false,
            isDestructiveAction: true,
            onPressed: () async {
              var res;
              if (userType == 'Teacher') {
                res = await model.endLive(widget.course.sId);
                Navigator.pop(context);

                pushNewScreen(context,
                    screen: const MainUITeacher(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.fade);
              } else {
                res = await model.leave(widget.course.sId);
                Navigator.pop(context);

                pushNewScreen(context,
                    screen: MainUI(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.fade);
              }
            },
            child: Text(locale.get("Confirm")),
          ),
        ],
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    // _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    // _engine.switchCamera();
  }

  TextEditingController _commentController = TextEditingController();
  FocusNode _commentFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StartLiveModel>(
        create: (context) => StartLiveModel(context),
        child: Consumer<StartLiveModel>(builder: (context, model, __) {
          final locale = AppLocalizations.of(context);
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                extendBody: true,
                appBar: AppBar(
                  centerTitle: false,
                  title: Text(widget.course.name.localized(context),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor)),

                  toolbarHeight: SizeConfig.heightMultiplier * 10,
                  actions: [_toolbar(model)],

                  // leading: InkWell(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: Icon(
                  //     Icons.arrow_back_ios,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  backgroundColor: Colors.white,
                  // elevation: 4s.0,
                ),
                backgroundColor: Colors.white,
                body: Container(
                  height: SizeConfig.heightMultiplier * 90,
                  child: Stack(
                    children: [
                      Align(alignment: Alignment.topCenter, child: _viewRows()),
                      // Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(bottom: 16.0),
                      //       child: _toolbar(),
                      //     )),
                      Align(
                          alignment: Alignment.center, child: _panel(context)),
                    ],
                  ),
                )),
          );
        }));
  }
}
