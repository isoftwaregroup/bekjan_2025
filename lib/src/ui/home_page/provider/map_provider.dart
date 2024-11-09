import 'dart:async';

import 'package:app/src/helpers/position_maneger.dart';
import 'package:app/src/network/client.dart';
import 'package:app/src/network/http_result.dart';
import 'package:app/src/ui/home_page/models/marker_model.dart';
import 'package:app/src/ui/home_page/models/tarif_odel.dart';
import 'package:app/src/ui/home_page/provider/home_provider.dart';
import 'package:app/src/ui/home_page/provider/service_provider.dart';
import 'package:app/src/utils/utils.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinput/pinput.dart';

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
  Map<MarkerId, Marker> markers = {};
  LatLng centerPosition = LatLng(40, 71);
  LatLng? currentPosition;
  String currentPositionTitle = '';
  GoogleMapController? googleMap;
  double zoom = 17.6;
  int distance = 0, durationTime = 0;
  List<LatLng> route = [];
  List<LatLng> driverRoute = [];
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
            markers[MarkerId(merkermodel.id)] = Marker(
              markerId: MarkerId(merkermodel.id),
              position: LatLng(
                merkermodel.latLng!.latitude,
                merkermodel.latLng!.longitude,
              ),
              rotation: merkermodel.angle.toDouble(),
              icon: car,
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
  void moveToPosition(LatLng point) {
    if (googleMap != null) {
      googleMap!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: point,
          zoom: zoom,
        ),
      ));
    }
    serviceCounter.isPositionChanget = true;
    mapScrollstate.sink.add(false);
    if (homeNotifier.conditionKey.isEmpty && homeNotifier.isWhere != null) {
      if (distance > 10 || homeNotifier.isWhere != false) {
        final isWhere = homeNotifier.isWhere;
        homeNotifier.setStreet(point).then((value) {
          if (isWhere == true) {
            homeNotifier.whereController.setText(value.toString());
          } else if (isWhere == false) {
            homeNotifier.whereGoController.setText(value.toString());
          }
        });
      }
      loadCardata(point);
      serviceCounter.loadTarifs();
    }
  }

  /// Xaritaga markerni qo'yadi agar bor bolsa o'zgartiradi
  void setMarker(Marker marker) async {
    if (googleMap != null) {
      markers[marker.markerId] = marker;
      notifyListeners();
    }
  }

  /// Ikki nuqta orasidagi marshrutni chizadi
  /// agar isUser true bolsa chiziq rangi kok aks holda sariq boladi
  Future<MainModel> drawRoute(bool isUser, LatLng where, LatLng whereGo) async {
    late MainModel result;
    for (int i = 0; i < 2; i++) {
      result = await client.get(
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
            final line = List<LatLng>.generate(
                coordinates.length,
                (index) =>
                    LatLng(coordinates[index].last, coordinates[index].first));
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
          return result;
        }
      } catch (e) {
        print(e);
      }
    }
    notifyListeners();
    return result;
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

/// Xarita malumotlarini yuklab olish
Future<void> loadMapAssets() async {
  darkMap = await rootBundle.loadString(assetLinks.darkMap);
  car = await getBitmap(
    asset: images.car,
    size: 80,
  );
  startMarker = await getBitmap(
    asset: images.start,
    size: 120,
  );
  endMarker = await getBitmap(
    asset: images.finish,
    size: 120,
  );
}
