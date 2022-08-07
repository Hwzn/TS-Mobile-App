import 'dart:async';

import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController {
  SocketController() {
    connectAndListen();
  }
  StreamSocket streamSocket = StreamSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
  void connectAndListen() {
    IO.Socket socket = IO.io('http://localhost:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());
    socket.onError((data) {
      // Logger().wtf('error $data');
    });
    socket.onConnect((_) {
      // Logger().wtf('connect');
      socket.emit('msg', 'test');
    });

    //When an event recieved from server, data is added to the stream
    socket.on('event', (data) => streamSocket.addResponse);
    socket.onDisconnect((_) => print('disconnect'));
  }
}

// Stream setup
class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
