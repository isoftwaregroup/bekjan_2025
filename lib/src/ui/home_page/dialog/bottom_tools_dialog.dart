import 'dart:io';

import 'package:app/src/helpers/widgets.dart';
import 'package:app/src/ui/home_page/dialog/tarif_dialog.dart';
import 'package:app/src/ui/home_page/dialog/tools_dialog.dart';
import 'package:app/src/ui/home_page/widgets/tarif_item.dart';
import 'package:app/src/utils/utils.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:app/src/widgets/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinput/pinput.dart';

import '../../../helpers/apptheme.dart';
import '../provider/home_provider.dart';
import '../provider/map_provider.dart';
import '../provider/service_provider.dart';
import 'search_bar.dart';

class BottomToolsdialog extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  BottomToolsdialog({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: mapNotifier.mapScrollStream,
      builder: (context, snapshot) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: serviceCounter.isWhereHide != null
              ? 140.o
              : snapshot.data == true
                  ? 30.o
                  : (Platform.isIOS ? 320.o : 310.o),
          decoration: theme.cardDecor.copyWith(
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.o),
            topLeft: Radius.circular(20.o),
          )),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final notifier = ref.watch(servicesProvider);
              int addedCost = 0;
              List<String> list = [];
              for (final service in notifier.services.take(50)) {
                if (service.isActive) {
                  list.add(service.id);
                  addedCost += service.cost;
                }
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (notifier.isWhereHide != false)
                    InkWell(
                      onTap: () {
                        homeNotifier.isWhere = true;
                        showBottomDialog(AdressBar(), context);
                        _onchange();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 20.o, bottom: 10.o, right: 16.o),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Consumer(builder: (BuildContext context,
                                WidgetRef ref, Widget? child) {
                              final colorCode = ref.watch(colorUpdateProvider);
                              return AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                width: 18.o,
                                height: 18.o,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.o),
                                  border: Border.all(
                                    width: 3.6.o,
                                    color: colorCode ||
                                            homeNotifier.isWhere == false
                                        ? theme.yellow
                                        : Colors.black,
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                  left: 15.o,
                                ),
                              );
                            }),
                            SizedBox(
                              width: 10.o,
                            ),
                            Expanded(
                              child: Text(
                                homeNotifier.whereController.text.isEmpty
                                    ? yourLocation.tr
                                    : homeNotifier.whereController.text,
                                style: theme.textStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.o,
                                  color:
                                      homeNotifier.whereController.text.isEmpty
                                          ? theme.grey
                                          : theme.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Container(
                    width: 560.w,
                    height: 0.7.o,
                    color: theme.line,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                  ),
                  if (notifier.isWhereHide != true)
                    InkWell(
                      onTap: () {
                        homeNotifier.isWhere = false;
                        if (mapNotifier.markers[homeNotifier.whereId] == null) {
                          setEditableMarker(
                            homeNotifier.whereId,
                            mapNotifier.centerPosition,
                          );
                        }
                        showBottomDialog(AdressBar(), context);
                        _onchange();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: notifier.isWhereHide == null ? 10.o : 20.o,
                          right: 16.o,
                          bottom: 12.o,
                        ),
                        child: Row(
                          children: [
                            Consumer(builder: (BuildContext context,
                                WidgetRef ref, Widget? child) {
                              final colorCode = ref.watch(colorUpdateProvider);
                              return Stack(
                                children: [
                                  AnimatedOpacity(
                                    duration: const Duration(seconds: 1),
                                    opacity: colorCode ||
                                            homeNotifier.isWhere == true
                                        ? 1
                                        : 0,
                                    child: Container(
                                      width: 18.o,
                                      height: 18.o,
                                      margin: EdgeInsets.only(
                                        left: 15.o,
                                      ),
                                      child: SvgPicture.asset(
                                        svgIcon.location,
                                        colorFilter: ColorFilter.mode(
                                          theme.mainBlue,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    duration: const Duration(seconds: 1),
                                    opacity: colorCode ||
                                            homeNotifier.isWhere == true
                                        ? 0
                                        : 1,
                                    child: Container(
                                      width: 18.o,
                                      height: 19.o,
                                      margin: EdgeInsets.only(
                                        left: 15.o,
                                      ),
                                      child: SvgPicture.asset(
                                        svgIcon.location,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.green,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            SizedBox(
                              width: 10.o,
                            ),
                            Expanded(
                              child: Text(
                                homeNotifier.whereGoController.text.isEmpty
                                    ? finalLocation.tr
                                    : homeNotifier.whereGoController.text,
                                style: theme.textStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.o,
                                  color: homeNotifier
                                          .whereGoController.text.isEmpty
                                      ? theme.grey
                                      : theme.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Container(
                    width: 560.w,
                    height: 0.7.o,
                    color: theme.line,
                    margin: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      bottom: 10.o,
                    ),
                  ),
                  if (notifier.isWhereHide == null)
                    Container(
                      width: 600.w,
                      height: 110.o,
                      margin: EdgeInsets.only(bottom: 10.o),
                      child: ListView.builder(
                        controller: _controller,
                        itemCount: notifier.tarifs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, index) {
                          return TarifItem(
                            onTap: () {
                              notifier.setTarifIndex(index);
                              final offset = 141.o * (index - 1);
                              if (offset >= 0) {
                                _controller.animateTo(
                                  offset,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuart,
                                );
                              }
                            },
                            title: notifier.tarifs[index].name,
                            cost:
                                '${numberFormat((notifier.tarifs[index].value + addedCost).toString())} UZS',
                            img: notifier.tarifs[index].img,
                            margin: EdgeInsets.only(
                              left: index == 0 ? 16.o : 0,
                              right: index == (notifier.tarifs.length - 1)
                                  ? 16.o
                                  : 0,
                            ),
                            isSelected: index == notifier.tarifIndex,
                            onSelect: () {
                              showBottomDialog(
                                  TarifDialog(
                                    onSetOrder: () {
                                      notifier.setTarifIndex(index);
                                      final offset = 141.o * (index - 1);
                                      if (offset >= 0) {
                                        _controller.animateTo(
                                          offset,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOutQuart,
                                        );
                                      }
                                    },
                                    data: notifier.tarifs[index],
                                    index: index,
                                    cost:
                                        '${numberFormat((notifier.tarifs[index].value + addedCost).toString())} UZS',
                                  ),
                                  context);
                            },
                          );
                        },
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final whereMarker = homeNotifier.isWhere == true ||
                                    mapNotifier.markers[homeNotifier.whereId] ==
                                        null
                                ? setEditableMarker(
                                    homeNotifier.whereId,
                                    serviceCounter.isWhereHide == true ||
                                            homeNotifier.isWhere == true
                                        ? mapNotifier.centerPosition
                                        : mapNotifier.currentPosition ??
                                            mapNotifier.centerPosition,
                                  )
                                : mapNotifier.markers[homeNotifier.whereId]!;
                            Marker? whereGoMarker =
                                mapNotifier.markers[homeNotifier.whereGoId];
                            if (serviceCounter.isWhereHide == false) {
                              print('where go set');
                              whereGoMarker = setEditableMarker(
                                  homeNotifier.whereGoId,
                                  mapNotifier.centerPosition);
                              if (homeNotifier.whereController.text.isEmpty) {
                                homeNotifier
                                    .setStreet(whereMarker.position)
                                    .then((value) {
                                  homeNotifier.whereController
                                      .setText(value.toString());
                                });
                              }
                            }
                            if (!homeNotifier.streetLoading) {
                              if (notifier.isPositionChanget) {
                                notifier.isPositionChanget = false;
                                if (homeNotifier.isWhere == false) {
                                  whereGoMarker = setEditableMarker(
                                      homeNotifier.whereGoId,
                                      mapNotifier.centerPosition);
                                }
                                if (whereGoMarker?.position != null) {
                                  notifier.isWhereHide = null;
                                  homeNotifier.update();
                                  mapNotifier.mapScrollstate.sink.add(false);
                                  mapNotifier
                                      .drawRoute(
                                    true,
                                    whereMarker.position,
                                    whereGoMarker!.position,
                                  )
                                      .then((result) {
                                    if (result.status != 200) {
                                      toast(
                                          context: context,
                                          txt: result.message);
                                    } else {
                                      homeNotifier.isWhere = null;
                                      mapNotifier.update();
                                      homeNotifier.update();
                                    }
                                  });
                                  return;
                                }
                              }
                              if (whereGoMarker?.position.latitude == null ||
                                  whereGoMarker?.position.longitude == null) {
                                homeNotifier.whereGoController.setText('-');
                              }
                              int cost = notifier.tarifs.isEmpty
                                  ? 0
                                  : notifier.tarifs[notifier.tarifIndex].value;
                              homeNotifier.newOrder({
                                'mode_id': serviceCounter
                                    .tarifs[serviceCounter.tarifIndex].id,
                                'cost': cost + addedCost,
                                'distance': mapNotifier.distance,
                                'latitude1': whereMarker.position.latitude,
                                'longitude1': whereMarker.position.longitude,
                                'latitude2': whereGoMarker?.position.latitude,
                                'longitude2': whereGoMarker?.position.longitude,
                                'address1':
                                    homeNotifier.whereController.text.isEmpty
                                        ? '-'
                                        : homeNotifier.whereController.text,
                                'address2':
                                    homeNotifier.whereGoController.text.isEmpty
                                        ? '-'
                                        : homeNotifier.whereGoController.text,
                                'services': list,
                                'comment': homeNotifier.commentText,
                              });
                            }
                          },
                          child: Container(
                              height: 50.o,
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10.o,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.o),
                                color: theme.yellow,
                              ),
                              child: Text(
                                notifier.isWhereHide != null ||
                                        (notifier.isPositionChanget &&
                                            homeNotifier.isWhere == false)
                                    ? comfirm.tr
                                    : setOrder.tr,
                                style: theme.textStyle.copyWith(
                                  fontSize: 18.o,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(
                                      homeNotifier.streetLoading ? 0.5 : 1),
                                ),
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showBottomDialog(const ToolsDialg(), context);
                        },
                        child: Container(
                          height: 50.o,
                          width: 50.o,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.o),
                            color: theme.greyBG,
                          ),
                          margin: EdgeInsets.only(right: 16.o),
                          child: SvgPicture.asset(
                            svgIcon.slider,
                            height: 25.o,
                            width: 25.o,
                            colorFilter: ColorFilter.mode(
                              (homeNotifier.commentText.isNotEmpty ||
                                      homeNotifier.services.isNotEmpty)
                                  ? theme.yellow
                                  : theme.text,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Platform.isIOS ? 30.o : 20.o,
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Marker setEditableMarker(MarkerId id, LatLng position) {
    final marker = Marker(
      markerId: id,
      position: position,
      onTap: () {
        mapNotifier.markers.removeWhere((key, value) {
          if (homeNotifier.conditionKey.isEmpty && key == id) {
            homeNotifier.isWhere = id == homeNotifier.whereId;
            mapNotifier.moveToPosition(value.position);
            mapNotifier.route.clear();
            mapNotifier.driverRoute.clear();
            mapNotifier.update();
            homeNotifier.update();
            serviceCounter.update();
            return key == id;
          }
          return false;
        });
      },
      icon: id == homeNotifier.whereId ? startMarker : endMarker,
    );
    mapNotifier.setMarker(marker);
    return marker;
  }

  void _onchange() {
    if (homeNotifier.isWhere == true) {
      mapNotifier.markers.remove(homeNotifier.whereId);
    } else if (homeNotifier.isWhere == false) {
      mapNotifier.markers.remove(homeNotifier.whereGoId);
    }
    mapNotifier.route.clear();
    mapNotifier.driverRoute.clear();
    serviceCounter.update();
    mapNotifier.update();
    homeNotifier.update();
  }
}
