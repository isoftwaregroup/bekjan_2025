import 'dart:async';
import 'dart:convert';

import 'package:app/src/network/client.dart';
import 'package:app/src/network/http_result.dart';
import 'package:app/src/ui/home_page/models/place_model.dart';
import 'package:app/src/ui/home_page/models/tarif_odel.dart';
import 'package:app/src/ui/home_page/provider/map_provider.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/service_model.dart';

final servicesProvider = ChangeNotifierProvider<Counter>((ref) {
  return serviceCounter;
});

final colorUpdateProvider = StateNotifierProvider<Clock, bool>((ref) {
  return Clock();
});

class Clock extends StateNotifier<bool> {
  Clock() : super(true) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = !state;
    });
  }

  late final Timer _timer;
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

Counter? _counter;
Counter get serviceCounter {
  _counter ??= Counter();
  return _counter!;
}

class Counter with ChangeNotifier {
  int tarifIndex = 0;
  List<TarifModel> tarifs = [];
  List<SericeModel> services = [];
  List<PlaceModel> places = [];
  FocusNode whereNode = FocusNode(), whereGoNode = FocusNode();
  bool? isWhereHide;
  bool isPositionChanget = false;
  Counter() {
    setPlaces();
    if (services.isEmpty) {
      getServises();
    }
  }

  @override
  void dispose() {
    try {
      whereGoNode.dispose();
      whereNode.dispose();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  Future<int> getServises() async {
    MainModel result = await client.get(
      Links.services,
    );
    if (result.status == 200) {
      final list = List<SericeModel>.from(
          result.data.map((x) => SericeModel.fromJson(x)));
      if (list.isNotEmpty) {
        services = list;
        notifyListeners();
      }
    }
    return result.status;
  }

  Future<int> loadTarifs() async {
    LatLng? location = mapNotifier.centerPosition;
    if (location.latitude == 40 && location.longitude == 71) {
      location = mapNotifier.currentPosition;
    }
    MainModel result = await client.get(
        '${Links.tarifs}?latitude=${mapNotifier.currentPosition?.latitude}&longitude=${mapNotifier.currentPosition?.longitude}');
    if (result.status == 200) {
      if (result.data is List) {
        tarifs = List<TarifModel>.from(
            result.data.map((x) => TarifModel.fromJson(x)));
        notifyListeners();
      }
    }
    return result.status;
  }

  void setTarifIndex(int index) {
    tarifIndex = index;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void setPlaces() async {
    final int day = pref.getInt('lastPlacesSettedDay') ?? -1;
    final int today = DateTime.now().day;
    if (day != today) {
      MainModel result = await client.get(Links.places);
      if (result.status == 200) {
        if (result.data is List) {
          places = List<PlaceModel>.from(
              result.data.map((x) => PlaceModel.fromJson(x)));
          pref.setStringList(
              'searchedPlaces',
              List.generate(places.length,
                  (index) => jsonEncode(places[index].toJson())));
          pref.setInt('lastPlacesSettedDay', today);
        }
      }
    } else {
      final list = pref.getStringList('searchedPlaces');
      if (list != null) {
        places = List.generate(list.length,
            (index) => PlaceModel.fromJson(jsonDecode(list[index])));
      }
    }
  }
}
