import 'package:bekjan/src/helpers/apptheme.dart';
import 'package:bekjan/src/ui/home_page/provider/map_provider.dart';
import 'package:bekjan/src/ui/home_page/provider/service_provider.dart';
import 'package:bekjan/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../../variables/util_variables.dart';
import '../provider/home_provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

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
        return FlutterMap(
          mapController: notifier.mapController,
          options: MapOptions(
            center: notifier.currentPosition,
            maxZoom: 18,
            minZoom: 11,
            zoom: notifier.zoom,
            onMapReady: () {
              notifier.centerPosition = notifier.currentPosition!;
              mapNotifier.loadCardata(notifier.centerPosition);
            },
            onMapEvent: (mapEvent) {
              notifier.zoom = mapEvent.camera.zoom;
              if (homeNotifier.isWhere == null) return;
              notifier.centerPosition = mapEvent.camera.center;
              final distance = distanse(
                notifier.currentPosition!.latitude,
                notifier.currentPosition!.longitude,
                mapEvent.camera.center.latitude,
                mapEvent.camera.center.longitude,
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
              if (mapEvent is MapEventMoveStart) {
                if (homeNotifier.isWhere!) {
                  notifier.markers
                      .removeWhere((key, value) => key == homeNotifier.whereId);
                } else {
                  notifier.markers.removeWhere(
                      (key, value) => key == homeNotifier.whereGoId);
                }
                notifier.update();
              }
              if (mapEvent is MapEventFlingAnimationEnd ||
                  mapEvent is MapEventFlingAnimationNotStarted) {
                serviceCounter.isPositionChanget = true;
                notifier.mapScrollstate.sink.add(false);
                if (homeNotifier.conditionKey.isEmpty &&
                    homeNotifier.isWhere != null) {
                  if (distance > 10 || homeNotifier.isWhere != false) {
                    final isWhere = homeNotifier.isWhere;
                    homeNotifier
                        .setStreet(notifier.centerPosition)
                        .then((value) {
                      if (isWhere == true) {
                        homeNotifier.whereController.setText(value.toString());
                      } else if (isWhere == false) {
                        homeNotifier.whereGoController
                            .setText(value.toString());
                      }
                    });
                  }
                  mapNotifier.loadCardata(notifier.centerPosition);
                  serviceCounter.loadTarifs();
                }
              } else if (mapEvent is MapEventMoveStart) {
                notifier.mapScrollstate.sink.add(true);
              }
            },
          ),
          children: [
            getMode(
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
            ),
            MouseRegion(
              hitTestBehavior: HitTestBehavior.deferToChild,
              cursor: SystemMouseCursors.click,
              child: PolylineLayer(
                polylines: [notifier.route, notifier.driverRoute],
              ),
            ),
            MarkerLayer(markers: notifier.markers.values.toList()),
          ],
        );
      },
    );
  }

  Widget getMode(TileLayer tileLayer) {
    return isDark
        ? ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              -1,
              0,
              0,
              0,
              255,
              0,
              -1,
              0,
              0,
              255,
              0,
              0,
              -1,
              0,
              255,
              0,
              0,
              0,
              1,
              0,
            ]),
            child: tileLayer,
          )
        : tileLayer;
  }
}
