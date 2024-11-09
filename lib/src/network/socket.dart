import 'dart:async';
import 'dart:convert';

import 'package:app/src/network/http_result.dart';
import 'package:app/src/ui/home_page/provider/home_provider.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

SocketConnection? _socketProvider;

SocketConnection get socket {
  _socketProvider ??= SocketConnection();
  return _socketProvider!;
}

class SocketConnection {
  IOWebSocketChannel? _webSocket;
  bool shouldReconnect = true;

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  set isConnected(bool value) {
    if (_isConnected != value) {
      _isConnected = value;
      sendSocketStatusBroadcast();
    }
  }

  StreamSubscription? _reconnectJob;
  bool reconnecting = false;

  final ValueNotifier<bool> socketLive = ValueNotifier<bool>(false);

  void sendSocketStatusBroadcast() {
    socketLive.value = isConnected;
  }

  void initSocket() {
    print('Socket ochildi');
    String token = pref.getString('token') ?? '';

    if (_reconnectJob != null || isConnected) {
      print('Socket ulangan qayta ulanmaslik uchun!');
      return;
    }

    connectSocket(token);
    reconnectJob(token);
  }

  void connectSocket(String token) async {
    shouldReconnect = true;

    try {
      print('Socket ulandi');
      final uri = Uri.parse('${Links.socketLink}$token');
      _webSocket = IOWebSocketChannel.connect(uri);
      _webSocket?.stream.listen((message) {
        onMessage(message);
        final jsonData = jsonDecode(message);
        MainModel? data = MainModel.fromJson(jsonData);
        homeNotifier.listenSocket(data);
      }, onDone: () {
        onClose();
      }, onError: (error) {
        onError(error, token);
      });

      isConnected = true;
      socketLive.value = true;
      print("WebSocket connected");
    } catch (error) {
      onError(error, token);
    }
  }

  void onMessage(String data) {
    print("xabar: $data");
    // final orderResponse = jsonDecode(data);

    // if (orderResponse['key'] == "order_new") {
    //   print("New order received");
    //   onMessageReceived();
    // }

    // handleSocketMessage(data);
  }

  void onClose() {
    String token = pref.getString('token') ?? '';
    print("Socket closed");
    isConnected = false;
    socketLive.value = false;
    // userPreferenceManager.saveToggleState(false);

    if (shouldReconnect) {
      reconnectJob(token);
    }
  }

  void onError(dynamic error, String token) {
    print("Socket error: $error");
    isConnected = false;
    socketLive.value = false;
    if (shouldReconnect) {
      reconnectJob(token);
    }
  }

  void reconnectJob(String token) {
    if (reconnecting || isConnected) return;

    reconnecting = true;
    _reconnectJob = Future.delayed(
        Duration(milliseconds: SocketUtil.RECONNECT_DELAY_MS), () {
      reconnecting = false;
      connectSocket(token);
    }).asStream().listen((_) {});
  }

  void disconnectSocket() {
    isConnected = false;
    shouldReconnect = false;
    _reconnectJob?.cancel();
    _reconnectJob = null;
    _webSocket?.sink.close();
  }
}

class SocketUtil {
  static const int RECONNECT_DELAY_MS = 5000;
}

enum SocketChecker {
  ORDER_ACCEPTED,
  ORDER_CANCELLED,
  ORDER_DRIVER_ARRIVED,
  ORDER_STARTED,
  ORDER_COMPLETED,
}
