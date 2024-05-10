import 'dart:async';

import 'package:bekjan/src/helpers/apptheme.dart';
import 'package:bekjan/src/helpers/position_maneger.dart';
import 'package:bekjan/src/network/client.dart';
import 'package:bekjan/src/network/http_result.dart';
import 'package:bekjan/src/ui/home_page/models/marker_model.dart';
import 'package:bekjan/src/ui/home_page/models/tarif_odel.dart';
import 'package:bekjan/src/ui/home_page/provider/home_provider.dart';
import 'package:bekjan/src/ui/home_page/provider/service_provider.dart';
import 'package:bekjan/src/variables/icons.dart';
import 'package:bekjan/src/variables/language.dart';
import 'package:bekjan/src/variables/links.dart';
import 'package:bekjan/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

ChangeNotifierProvider<MapNotifier> mapProvider =
    ChangeNotifierProvider<MapNotifier>((ref) {
  return mapNotifier;
});

MapNotifier? _mapNotifier;
MapNotifier get mapNotifier {
  _mapNotifier ??= MapNotifier();
  return _mapNotifier!;
}

class MapNotifier with ChangeNotifier {
  Map<Key, Marker> markers = {};
  LatLng centerPosition = LatLng(40, 71);
  LatLng? currentPosition;
  String currentPositionTitle = '';
  MapController mapController = MapController();
  double zoom = 17.6;
  int distance = 0, durationTime = 0;
  Polyline route = Polyline(points: []), driverRoute = Polyline(points: []);
  StreamController<bool> mapScrollstate = StreamController<bool>.broadcast();
  Stream<bool> get mapScrollStream => mapScrollstate.stream;

  void update() {
    notifyListeners();
  }

  /// Xarita birinchi ekranga chiqishi positsiyasi bo'lishi zarur
  Future<LatLng> setCurentPosition() async {
    final initialPosition =
        await positionManeger.determinePosition().onError((e, stackTrace) {
      return Future.error(permitLocation.tr);
    });
    if (initialPosition.latitude != null && initialPosition.longitude != null) {
      currentPosition =
          LatLng(initialPosition.latitude!, initialPosition.longitude!);
    }
    notifyListeners();
    return currentPosition!;
  }

  /// 600m radiusdagi mashinalarni xaritaga chiqaradi.
  void loadCardata(LatLng position) async {
    MainModel result = await client.get(
      '${Links.getCars}?latitude=${position.latitude}&longitude=${position.longitude}&radius=600',
    );
    if (result.status == 200) {
      if (result.data is List) {
        for (final value in result.data) {
          MarkerModel merkermodel = MarkerModel.fromJson(value);
          if (merkermodel.latLng != null) {
            markers[Key(merkermodel.id)] = Marker(
              key: Key(merkermodel.id),
              width: 40.o,
              height: 80.o,
              point: LatLng(
                  merkermodel.latLng!.latitude, merkermodel.latLng!.longitude),
              child: Transform.rotate(
                angle: merkermodel.angle.toDouble(),
                child: Image.asset(
                  images.car,
                ),
              ),
            );
          }
        }
        notifyListeners();
      }
    }
  }

  /// Xarita markazini foydalanuvchi turgan joyga olib boradi
  void moveToMyPosition() {
    if (currentPosition != null) {
      moveToPosition(currentPosition!);
    }
    setCurentPosition().then((value) {
      moveToPosition(value);
    });
  }

  /// Xarita markazini foydalanuvchi turgan joyga olib boradi
  void moveToPosition(LatLng point) => mapController.move(point, zoom);

  /// Xaritaga markerni qo'yadi agar bor bolsa o'zgartiradi
  void setMarker(Marker marker) async {
    markers[marker.key ?? const Key('')] = marker;
    notifyListeners();
  }

  /// Ikki nuqta orasidagi marshrutni chizadi
  /// agar isUser true bolsa chiziq rangi kok aks holda sariq boladi
  Future<bool> drawRoute(bool isUser, LatLng where, LatLng whereGo) async {
    for (int i = 0; i < 2; i++) {
      final MainModel result = await client.get(
          '${Links.drawLink}?start=${where.longitude},${where.latitude}&end=${whereGo.longitude},${whereGo.latitude}');
      try {
        distance = int.tryParse(result.data['distance'].toString()) ?? 0;

        /// bu kommentni olish orqali yol summasi hisoblanadi.
        serviceCounter.tarifs = List<TarifModel>.from(
            result.data['modes'].map((x) => TarifModel.fromJson(x)));
        serviceCounter.update();
        List list = result.data['ors']['features'] ?? [];
        if (list.isNotEmpty) {
          List<dynamic> coordinates = list.first['geometry']['coordinates'];
          if (coordinates.isNotEmpty) {
            final list = List<LatLng>.generate(
                coordinates.length,
                (index) =>
                    LatLng(coordinates[index].last, coordinates[index].first));
            final line = Polyline(
              points: list,
              strokeWidth: 6.o,
              color: isUser
                  ? isDark
                      ? theme.blue
                      : theme.mainBlue
                  : theme.yellow,
            );
            if (isUser) {
              route = line;
            } else {
              driverRoute = line;
            }
          }
          if (list.isNotEmpty) {
            final value = list.first['properties']['summary']['duration'];
            if (value is int) {
              durationTime = value;
            }
          }
          notifyListeners();
          return true;
        }
      } catch (e) {
        print(e);
      }
    }
    notifyListeners();
    return false;
  }

  /// Xaritadagi barcha markerlar va chiziqlarni olib tashlaydi,
  /// hamda xaritani foydalanuvchi turgan joyga olib keladi.
  void clearAll() {
    markers.clear();
    moveToMyPosition();
    if (currentPosition != null) {
      homeNotifier.setStreet(currentPosition!);
    }
    notifyListeners();
  }
}
