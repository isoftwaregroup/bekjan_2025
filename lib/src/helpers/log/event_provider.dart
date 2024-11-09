import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ChangeNotifierProvider<EventNotifier> eventProvider =
    ChangeNotifierProvider<EventNotifier>((ref) {
  return eventNotifier;
});

EventNotifier? _eventNotifier;
EventNotifier get eventNotifier {
  _eventNotifier ??= EventNotifier();
  return _eventNotifier!;
}

class EventNotifier with ChangeNotifier {
  EventNotifier() {
    list = (pref.getStringList(key) ?? []).reversed.toList();
  }
  final key = 'logger_message';
  List<String> list = [];

  @override
  void dispose() {
    if (list.length > 500) {
      pref.setStringList(key, []);
    }
    super.dispose();
  }

  void clear() {
    pref.remove(key);
    list.clear();
    notifyListeners();
  }

  void log(String msg) async {
    list.add(msg);
    pref.setStringList(key, list);
    notifyListeners();
  }
}
