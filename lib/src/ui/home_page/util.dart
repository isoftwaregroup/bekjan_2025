import 'dart:convert';

import 'package:app/src/ui/home_page/provider/service_provider.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/ConnectionListner.dart';
import '../../network/client.dart';
import '../../network/http_result.dart';
import '../../variables/links.dart';
import '../../variables/util_variables.dart';
import 'models/service_model.dart';

Future<void> saveOrderServices() async {
  List<String> names = [];
  List<String> costs = [];
  for (final service in serviceCounter.services) {
    if (service.isActive) {
      names.add(service.name);
      costs.add(service.cost.toString());
    }
  }
  await pref.setStringList('services_names', names);
  await pref.setStringList('services_costs', costs);
}

Future<List<SericeModel>> getServices() async {
  List<String> names = pref.getStringList('services_names') ?? [];
  List<String> costs = pref.getStringList('services_costs') ?? [];
  if (names.length == costs.length && names.isNotEmpty) {
    return List<SericeModel>.generate(
        names.length,
        (index) => SericeModel(
            id: '',
            name: names[index],
            cost: int.tryParse(costs[index]) ?? 0,
            icon: ''));
  }
  return [];
}

Future<void> deleteServices() async {
  pref.remove('services_names');
  pref.remove('services_costs');
}

Future<bool> cancelCurrentOrder(String comment) async {
  MainModel result = await client.post(
    Links.cancelOrder,
    data: {'comment': comment},
  );
  if (result.status == 200) {
    return true;
  }
  return false;
}

//------------

void saveCurrentOrder(Map<String, dynamic> data) {
  pref.setString('setted_current_order', jsonEncode(data));
}

Map<String, dynamic> getCurrentOrder() {
  final data = jsonDecode(pref.getString('setted_current_order') ?? '{}');
  if (data is Map<String, dynamic>) {
    return data;
  }
  return {};
}

void deleteLastorder() {
  pref.remove('setted_current_order');
}

//-------------

Future<void> setDispacherLink() async {
  if (dispacherLink.isEmpty) {
    final pref = await SharedPreferences.getInstance();
    if (connectionListner.isOnline) {
      MainModel result = await client.post(Links.contact);
      if (result.status == 200) {
        dispacherLink = result.data['link'].toString();
        await pref.setString(
            'dispecher_link', dispacherLink.replaceAll(' ', ''));
      }
    } else {
      dispacherLink = pref.getString('dispecher_link') ?? '';
    }
  }
}

bool checkIsPath(double lat, double lon, List<LatLon> list) {
  return PolygonUtil.isLocationOnPath(
      LatLng(lat, lon),
      List.generate(
        list.length,
        (index) => LatLng(list[index].lat, list[index].lon),
      ),
      false,
      tolerance: 20);
}

class LatLon {
  LatLon(this.lat, this.lon);
  double lat;
  double lon;
}

//---------------

// double calculateMin(List<LatLng> locations, LatLng itemLatLng){
//   double minDis = 1000;
//   int minIndex = 0;
//   if(locations.length > 2){
//     for(int i = 0; i < locations.length; i++){
//       final dis = (locations[i].latitude - itemLatLng.latitude).abs() + (locations[i].longitude - itemLatLng.longitude).abs();
//       if(dis < minDis){
//         minDis = dis;
//         minIndex = i;
//       }
//     }
//     return minIndex / locations.length;
//   }
//   return 0;
// }
