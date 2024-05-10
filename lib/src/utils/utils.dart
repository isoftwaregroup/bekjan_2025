import 'dart:math';

const List<String> mounths = [
  'Yanvar',
  'Fevral',
  'Mart',
  'Aprel',
  'May',
  'Iyun',
  'Iyul',
  'Avgust',
  'Sentabr',
  'Oktabr',
  'Noyabr',
  'Dekabr'
];

String getDate(DateTime date) {
  String dmy = date.day.toString().padLeft(2, '0');
  dmy += '.${date.month.toString().padLeft(2, '0')}.';
  dmy += date.year.toString();
  return dmy;
}

String getDMY(int day, month, year) {
  String dmy = day.toString().padLeft(2, '0');
  dmy += '.${month.toString().padLeft(2, '0')}.';
  dmy += year.toString();
  return dmy;
}

DateTime detTimeDateOfString(String date) {
  final list = date.split('.');
  if (list.length == 3) {
    return DateTime(
      int.parse(list[2]),
      int.parse(list[1]),
      int.parse(list[0]),
    );
  }
  return DateTime(2000);
}

String numberFormat(String numbers) {
  String value = '';
  int index = 0;
  final regexp = RegExp(r'\d');
  numbers.split('').reversed.forEach((element) {
    if (regexp.hasMatch(element)) {
      if (index == 3) {
        value = ' $value';
        index = 0;
      }
      value = '$element$value';
      index++;
    }
  });
  return value;
}

String cut60(String txt) {
  if (txt.length > 60) {
    int size = 0;
    for (final word in txt.split(' ')) {
      size += word.length + 1;
      if (size > 59) {
        return '${txt.substring(0, size)}...';
      }
    }
  }
  return txt;
}

String setphoneNumberFormat(String numbers) {
  String result = '';
  int i = 0;
  numbers.split('').forEach((element) {
    if (i == 0) {
      result += '+';
    } else if (i == 3 || i == 5 || i == 8 || i == 10) {
      result += ' ';
    }
    result += element;
    i++;
  });
  return result;
}

String numToClock(int seconds) {
  return '${_counterFormat(seconds ~/ 60)}:${_counterFormat(seconds % 60)}';
}

String _counterFormat(int counter) {
  if (counter <= 9) {
    return "0$counter";
  } else {
    return counter.toString();
  }
}

double distanse(double lat1, double lon1, double lat2, double lon2) {
  final theta = lon1 - lon2;
  var dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
      (cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta)));
  dist = acos(dist);
  dist = rad2deg(dist);
  dist = dist *
      60; // 60 nautical miles  per degree of seperation  //Seperatsiya darajasiga 60 dengiz mil
  dist = dist *
      1852; // 1852 meters per nautial mile  // Har bir dengiz mili 1852 metr
  return dist;
}

double deg2rad(double deg) {
  return deg * pi / 180.0;
}

double rad2deg(double deg) {
  return deg * 180.0 / pi;
}
