import 'dart:convert';

import 'package:bekjan/src/helpers/ConnectionListner.dart';
import 'package:bekjan/src/variables/links.dart';
import 'package:bekjan/src/variables/util_variables.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../helpers/log/event_provider.dart';
import '../helpers/notification_service.dart';
import 'http_result.dart';

/// bu qism "_socketProvider" ni qayta yaratilmasligi uchun zarur.
SocketConnection? _socketProvider;
SocketConnection get socket {
  _socketProvider ??= SocketConnection();
  return _socketProvider!;
}

class SocketConnection {
  WebSocketChannel? _channel;
  Function(MainModel event)? _listenfun;
  Function? onReconnect;
  dynamic _pingMessage;
  bool isStop = false, isPlaying = false;
  void listen(Function(MainModel? model) listen) {
    _listenfun = listen;
  }

  void init() async {
    await NotificationService().createChannel('LIDER_TAXI');
    connectionListner.socketConnectionListner = (isOnline) {
      if (isOnline) {
        _connectWC();
      }
    };
    _connectWC();
  }

  Future<void> close() async {
    if (_channel != null) {
      onReconnect = null;
      return await _channel!.sink.close();
    }
  }

  Future<void> exit() async {
    close();
    isStop = true;
  }

  void _connectWC() async {
    String token = pref.getString('token') ?? '';
    if (isStop) {
      isStop = false;
      return;
    }
    if (token.isNotEmpty) {
      try {
        print('connecting to websocket ...');
        eventNotifier.log('connecting to websocket ...');
        if (_channel != null) {
          try {
            print('on Close');
            _channel!.sink.close().then((value) => print('closed'));
          } catch (e) {
            print('close error: $e');
          }
          _channel = null;
        }
        print('connecting');
        eventNotifier.log('connecting');
        _channel = WebSocketChannel.connect(
          Uri.parse('${Links.socketLink}$token'),
        );
        await _channel!.ready;
        // _sendPing();
        _channel!.stream.listen(
          (event) {
            MainModel model = MainModel.fromJson(jsonDecode(event));
            print('socket event: $event');
            if (model.key != 'pong') {
              eventNotifier.log(event.toString());
            }
            if (model.key == 'pong') {
              _pingMessage = model.data['message'];
            } else if (_listenfun != null) {
              _listenfun!(model);
            }
          },
          onDone: () async {
            print('on socket done.');
            eventNotifier.log('on socket done.');
            if (_pingMessage == null) {
              await Future.delayed(const Duration(seconds: 10));
            }
            _sendPing();
          },
          onError: (e) async {
            print('on error connecting socket.');
            eventNotifier.log('on error connecting socket.');
            // _tryAgain();
          },
        );
      } catch (e) {
        print('websocket connecting error');
        eventNotifier.log('websocket connecting error');
        _tryAgain();
      }
    }
    //_tryAgain();
  }

  void _sendPing() async {
    if (_channel != null) {
      try {
        _pingMessage = null;
        _channel!.sink.add('ping');
        print('ping sended');
        await Future.delayed(const Duration(seconds: 30));
      } catch (e) {
        print('cannot send ping: $e');
        eventNotifier.log('cannot send ping: $e');
      }
      if (_pingMessage != 'pong') {
        _tryAgain();
      } else {
        _sendPing();
      }
    } else {
      print('channel null');
      eventNotifier.log('channel null');
    }
  }

  void _tryAgain() async {
    print('next conection is 1 seconds later');
    eventNotifier.log('next conection is 1 seconds later');
    if (_channel != null) {
      try {
        _channel!.sink.close().then((value) => print('closed'));
        _channel = null;
      } catch (e) {
        print('close error: $e');
      }
    }
    await Future.delayed(const Duration(seconds: 10)).then((value) {
      _connectWC();
      if (onReconnect != null) {
        onReconnect!();
      }
    });
  }

  // @pragma('vm:entry-point')
  // void init(){
  //   Workmanager().executeTask((task, inputData) {
  //     connectionListner.socketConnectionListner = (isOnline){
  //       if(isOnline){
  //         _connectWC();
  //       }
  //     };
  //     _connectWC();
  //     return Future.value(true);
  //   });
  // }
}
