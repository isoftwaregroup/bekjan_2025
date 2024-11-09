import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/ui/home_page/provider/map_provider.dart';
import 'package:app/src/ui/home_page/provider/service_provider.dart';
import 'package:app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinput/pinput.dart';

import '../../../variables/util_variables.dart';
import '../provider/home_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double distance = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.watch(mapProvider);
        if (notifier.currentPosition == null) {
          return Container(
            color: theme.background,
          );
        }
        return GoogleMap(
          zoomGesturesEnabled: true,
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          style: isDark ? darkMap : lightMap,
          mapType: MapType.normal,
          markers: Set<Marker>.of(notifier.markers.values),
          polylines: <Polyline>{
            if (notifier.route.isNotEmpty)
              Polyline(
                polylineId: const PolylineId('route'),
                points: notifier.route,
                width: (6.o).toInt(),
                color: isDark ? theme.orange : theme.orange,
              ),
            if (notifier.driverRoute.isNotEmpty)
              Polyline(
                polylineId: const PolylineId('driverRoute'),
                points: notifier.driverRoute,
                width: (6.o).toInt(),
                color: theme.yellow,
              ),
          },
          initialCameraPosition: CameraPosition(
            target: notifier.currentPosition!,
            zoom: notifier.zoom,
          ),
          onMapCreated: (GoogleMapController mapController) {
            notifier.googleMap = mapController;
            notifier.centerPosition = notifier.currentPosition!;
            mapNotifier.loadCardata(notifier.centerPosition);
          },
          onCameraMove: (CameraPosition position) {
            print('camera move');
            notifier.zoom = position.zoom;
            if (homeNotifier.isWhere == null) return;
            notifier.centerPosition = position.target;
            distance = distanse(
              notifier.currentPosition!.latitude,
              notifier.currentPosition!.longitude,
              position.target.latitude,
              position.target.longitude,
            );
            if (distance < 100) {
              if (homeNotifier.isWhere == true &&
                  homeNotifier.whereGoController.text.isEmpty) {
                homeNotifier.whereController
                    .setText(notifier.currentPositionTitle);
              } else if (homeNotifier.isWhere == false &&
                  homeNotifier.whereGoController.text.isEmpty) {
                homeNotifier.whereGoController
                    .setText(notifier.currentPositionTitle);
              }
            } else {
              if (homeNotifier.isWhere == true &&
                  homeNotifier.whereController.text.isNotEmpty) {
                homeNotifier.whereController.setText('');
              } else if (homeNotifier.isWhere == false &&
                  homeNotifier.whereGoController.text.isNotEmpty) {
                homeNotifier.whereGoController.setText('');
              }
            }
          },
          onCameraMoveStarted: () {
            print('camera start');
            notifier.mapScrollstate.sink.add(true);
            if (homeNotifier.isWhere == true) {
              notifier.markers
                  .removeWhere((key, value) => homeNotifier.whereId == key);
            } else if (homeNotifier.isWhere == false) {
              notifier.markers
                  .removeWhere((key, value) => key == homeNotifier.whereGoId);
            }
          },
          onCameraIdle: () {
            print('camera end');
            notifier.mapScrollstate.sink.add(false);
            if (homeNotifier.isWhere == null) {
              return;
            }
            serviceCounter.isPositionChanget = true;
            if (homeNotifier.conditionKey.isEmpty &&
                homeNotifier.isWhere != null) {
              if (distance > 10 || homeNotifier.isWhere != false) {
                final isWhere = homeNotifier.isWhere;
                homeNotifier.setStreet(notifier.centerPosition).then((value) {
                  if (isWhere == true) {
                    homeNotifier.whereController.setText(value.toString());
                  } else if (isWhere == false) {
                    homeNotifier.whereGoController.setText(value.toString());
                  }
                });
              }
              mapNotifier.loadCardata(notifier.centerPosition);
              serviceCounter.loadTarifs();
            }
          },
        );
      },
    );
  }
}
