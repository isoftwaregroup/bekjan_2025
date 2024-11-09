import 'package:app/src/variables/language.dart';
import 'package:location/location.dart';

PositionManeger? _positionManeger;
PositionManeger get positionManeger {
  _positionManeger ??= PositionManeger();
  return _positionManeger!;
}

class PositionManeger {
  Location location = Location();

  Future<String?> _checkIsCan() async {
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return permitLocation.tr;
      } else {
        // i not write this code not getted current location in first time
        // await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission == PermissionStatus.denied) {
        print('12332123: permission denied');
        return permitLocation.tr;
      }
    }

    if (permission == PermissionStatus.deniedForever) {
      print('12332123: permission denied force');
      return workWell.tr;
    }
    return null;
  }

  Future<LocationData> determinePosition() async {
    final String? msg = await _checkIsCan();
    if (msg != null) {
      return Future.error(msg);
    }
    LocationData? locationdata = await Future.any([
      location.getLocation(),
      Future.delayed(const Duration(seconds: 5), () => null),
    ]);
    locationdata ??= await location.getLocation();
    if (locationdata.latitude != null) {
      return locationdata;
    } else {
      return Future.error('');
    }
  }
}
