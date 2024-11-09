import 'package:app/src/variables/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final driverProvider = ChangeNotifierProvider<Counter>((ref) {
  return driverCounter;
});

Counter? _counter;
Counter get driverCounter {
  _counter ??= Counter();
  return _counter!;
}

class Counter with ChangeNotifier {
  Counter() : super() {
    waitingMessage = '1 min';
    // waitingMessage = sameTime.tr;
  }

  String waitingMessage = '';
  int minutes = 0;
  String key = '';

  void setDataTime(int seconds) async {
    if (seconds ~/ 60 != minutes) {
      minutes = seconds ~/ 60;
      if (minutes > 1) {
        waitingMessage = '$minutes min';
      } else {
        waitingMessage = '1 min';
        // waitingMessage = almost.tr;
      }
      notifyListeners();
    } else if (seconds == 0) {
      waitingMessage = atTheAddress.tr;
      notifyListeners();
    }
  }

  void setIsStart(String conditionKey) {
    key = conditionKey;
    notifyListeners();
  }
}
