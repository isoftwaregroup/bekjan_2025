import 'package:app/src/helpers/notification_service.dart';
import 'package:app/src/helpers/widgets.dart';
import 'package:app/src/network/client.dart';
import 'package:app/src/network/http_result.dart';
import 'package:app/src/network/socket.dart';
import 'package:app/src/ui/home_page/dialog/set_rating.dart';
import 'package:app/src/ui/home_page/provider/driver_provider.dart';
import 'package:app/src/ui/home_page/provider/service_provider.dart';
import 'package:app/src/utils/utils.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinput/pinput.dart';

import '../../../variables/language.dart';
import '../models/order_model.dart';
import '../models/service_model.dart';
import '../util.dart';
import 'map_provider.dart';

ChangeNotifierProvider<HomeNotifier> homeProvider =
    ChangeNotifierProvider<HomeNotifier>((ref) {
  return homeNotifier;
});

HomeNotifier? _homeNotifier;

HomeNotifier get homeNotifier {
  _homeNotifier ??= HomeNotifier();
  return _homeNotifier!;
}

class HomeNotifier with ChangeNotifier {
  String commentText = '', conditionKey = '';
  List<SericeModel> services = [];
  bool? isWhere = true;
  DriverModel? driverModel;
  AnimationController? checkerController;
  bool streetLoading = false, orderLoad = false;
  final whereId = const MarkerId('whereId'),
      whereGoId = const MarkerId('whereGoId'),
      driverId = const MarkerId('driverId');

  TextEditingController whereController = TextEditingController(),
      whereGoController = TextEditingController();

  final player = AudioPlayer();

  void update() {
    notifyListeners();
  }

  /// ushbu funksiyani home pageda qiymatini berish zarur aks holda dialoglar chiqmaydi
  BuildContext Function()? homeContext;

  Future<LatLng?> getLocationFromaddress(String address) async {
    // avval lokal joy nomlariga tekshiradi agar yo'q bo'lsa keyin apiga murojat qiladi
    for (final place in serviceCounter.places) {
      if (place.name == address) {
        return LatLng(place.latitude, place.longitude);
      }
    }
    MainModel result = await client.get(
      '${Links.getLocationFromAdress}$address&key=$apiKey',
      withoutHeader: true,
    );
    try {
      if (result.status == 200) {
        List<Map<String, dynamic>> list =
            List<Map<String, dynamic>>.from(result.data.map((x) => x));
        if (list.isNotEmpty) {
          dynamic lat = list.first['geometry']['location']['lat'];
          dynamic lon = list.first['geometry']['location']['lng'];
          if (lat is double && lon is double && isWhere != null) {
            return LatLng(lat, lon);
          }
        }
      }
    } catch (e) {}
    return null;
  }

  /// Joylashuv boyicha manzilni oladi
  Future<String?> setStreet(LatLng latLng) async {
    double minDis = 1000;
    String placeName = '';
    // avval lokal joy nomlariga tekshiradi agar yo'q bo'lsa keyin apiga murojat qiladi
    for (final place in serviceCounter.places) {
      final dis = distanse(
        latLng.latitude,
        latLng.longitude,
        place.latitude,
        place.longitude,
      );
      if (minDis > dis) {
        minDis = dis;
        placeName = place.name;
      }
    }
    if (minDis < 400) {
      return placeName;
    }
    streetLoading = true;
    notifyListeners();
    MainModel result = await client.get(
        '${Links.addressFromLocation}&lat=${latLng.latitude}&lon=${latLng.longitude}');
    streetLoading = false;
    serviceCounter.update();
    update();
    notifyListeners();
    mapNotifier.mapScrollstate.sink.add(false);
    try {
      if (result.data is Map<String, dynamic>) {
        String address = '';
        if (result.data['address']['amenity'] != null) {
          address += result.data['address']['amenity'].toString();
        } else {
          address += result.data['address']['house_number'] ?? '';
        }
        address += ' ';
        if (result.data['address']['road'] != null) {
          address += result.data['address']['road'].toString();
        } else {
          address += result.data['address']['suburb'] ?? '';
        }
        address += ' ';
        if (result.data['address']['city'] != null) {
          address += result.data['address']['city'].toString();
        } else {
          address += result.data['address']['state'] ?? '';
        }
        return address;
      }
    } catch (e) {}
    return null;
  }

  void newOrder(Map<String, dynamic> info) async {
    if (!orderLoad) {
      orderLoad = true;
      notifyListeners();
      MainModel result = await client.post(
        Links.newOrder,
        data: info,
      );
      if (result.status == 200) {
        saveCurrentOrder(info);
        saveOrderServices();
        socket.initSocket();
        conditionKey = 'order_initial';
      }
      orderLoad = false;
      notifyListeners();
    }
  }

  void listenSocket(MainModel? event) {
    print("xabar listen");
    if (event != null) {
      conditionKey = event.key;
      //showMessage(conditionKey);
      try {
        if (conditionKey == 'order_accepted') {
          driverModel = DriverModel.fromJson(event.data);
          notifyListeners();
        } else if (conditionKey == 'car_location') {
          try {
            double? lat = double.tryParse(event.data['latitude'].toString());
            double? lon = double.tryParse(event.data['longitude'].toString());
            if (lat != null && lon != null) {
              LatLng point = LatLng(lat, lon);
              if (mapNotifier.driverRoute.isEmpty) {
                if (mapNotifier.markers[whereId] is Marker) {
                  final marker = mapNotifier.markers[whereId] as Marker;
                  mapNotifier.drawRoute(false, point, marker.position);
                }
              } else {
                final points = mapNotifier.driverRoute;
                if (!checkIsPath(
                    point.latitude,
                    point.longitude,
                    List.generate(
                        points.length,
                        (index) => LatLon(points[index].latitude,
                            points[index].longitude)))) {
                  if (mapNotifier.markers[whereId] is Marker) {
                    final marker = mapNotifier.markers[whereId] as Marker;
                    mapNotifier.drawRoute(false, point, marker.position);
                  }
                }
              }
              // mapNotifier.moveToPosition(point);
              mapNotifier.setMarker(Marker(
                markerId: driverId,
                position: point,
                icon: car,
              ));
            }
          } catch (e) {
            print(e);
            //showMessage(e.toString());
          }
        } else if (conditionKey == 'order_started') {
          driverCounter.setIsStart(conditionKey);
        } else if (conditionKey == 'order_driver_arrived') {
          player.play(AssetSource('raw/arrived.mp3'));
          NotificationService().showNotification(
            888,
            newMessage.tr,
            event.data['message'].toString(),
            '',
          );
        } else if (conditionKey == 'order_completed') {
          socket.disconnectSocket();
          isWhere = true;
          mapNotifier.clearAll();
          driverModel = null;
          if (homeContext != null) {
            showBottomDialog(
              RatingDialog(data: event.data),
              homeContext!(),
            );
          }
          Future.delayed(const Duration(seconds: 1)).then((value) {
            conditionKey = '';
            notifyListeners();
            whereGoController.setText('');
            whereController.setText('');
          });
          if (event.data['bonus'] is Map<String, dynamic>) {
            //showBonus(context,event.data['bonus']);
          }
        } else if (conditionKey == 'order_cancelled') {
          deleteServices();
          driverModel = null;
          deleteLastorder();
          socket.disconnectSocket();
          conditionKey = '';
          notifyListeners();
        }
      } catch (e) {
        print(e);
      }
      notifyListeners();
    }
  }

  void onReconnect() async {
    MainModel result = await client.post(Links.status);
    print('recnnect: ${result.key}');
    if (result.step == 0) {
      deleteServices();
      deleteLastorder();
    } else if (result.step == 5) {
      deleteServices();
      deleteLastorder();
      showBottomDialog(
          RatingDialog(
            data: result.data,
          ),
          homeContext!());
    } else {
      if (result.step == 3) {
      } else if (result.step == 4) {
        conditionKey == 'order_started';
        driverCounter.setIsStart(conditionKey);
      } else if (result.step == 2) {
        conditionKey == 'order_accepted';
        driverModel = DriverModel.fromJson(result.data);
      }
      notifyListeners();
    }
  }
}
