import 'dart:async';

import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/network/client.dart';
import 'package:app/src/network/http_result.dart';
import 'package:app/src/ui/home_page/provider/home_provider.dart';
import 'package:app/src/ui/home_page/provider/service_provider.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';

import '../provider/map_provider.dart';

List<String> resultData = [];

class AdressBar extends StatefulWidget {
  AdressBar({super.key});

  @override
  State<AdressBar> createState() => _AdressBarState();
}

class _AdressBarState extends State<AdressBar> {
  final StreamController<int> controller = StreamController<int>();

  Stream<int> get textStream => controller.stream;
  bool isHide = true;

  @override
  void dispose() {
    print('isHide:$isHide');
    if (isHide) {
      homeNotifier.isWhere = true;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              serviceCounter.whereNode.requestFocus();
              homeNotifier.isWhere = true;
              _onchange();
            },
            child: Padding(
              padding: EdgeInsets.only(
                top: 8.o,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Consumer(builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final colorCode = ref.watch(colorUpdateProvider);
                    return AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: 18.o,
                      height: 18.o,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.o),
                        border: Border.all(
                          width: 3.6.o,
                          color: colorCode || homeNotifier.isWhere == false
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
                    child: TextField(
                      controller: homeNotifier.whereController,
                      focusNode: serviceCounter.whereNode,
                      keyboardType: TextInputType.text,
                      autofocus: homeNotifier.isWhere == true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: theme.textStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.h,
                          color: theme.grey,
                        ),
                        hintText: yourLocation.tr,
                      ),
                      style: theme.textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.h,
                      ),
                      onChanged: searchFromAdress,
                      onTap: () {
                        homeNotifier.isWhere = true;
                        _onchange();
                      },
                    ),
                  ),
                  if (homeNotifier.isWhere == true)
                    InkWell(
                      onTap: () => homeNotifier.whereController.setText(''),
                      child: Padding(
                        padding: EdgeInsets.all(5.o),
                        child: SvgPicture.asset(
                          svgIcon.clear,
                          width: 14.o,
                          height: 14.o,
                        ),
                      ),
                    ),
                  SizedBox(
                    width: 16.o,
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
          InkWell(
            onTap: () {
              serviceCounter.whereGoNode.requestFocus();
              homeNotifier.isWhere == false;
              _onchange();
            },
            child: Row(
              children: [
                Consumer(builder:
                    (BuildContext context, WidgetRef ref, Widget? child) {
                  final colorCode = ref.watch(colorUpdateProvider);
                  return Stack(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(seconds: 1),
                        opacity:
                            colorCode || homeNotifier.isWhere == true ? 1 : 0,
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
                        opacity:
                            colorCode || homeNotifier.isWhere == true ? 0 : 1,
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
                  child: TextField(
                    controller: homeNotifier.whereGoController,
                    keyboardType: TextInputType.text,
                    focusNode: serviceCounter.whereGoNode,
                    autofocus: homeNotifier.isWhere == false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: theme.textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.h,
                        color: theme.grey,
                      ),
                      hintText: finalLocation.tr,
                    ),
                    style: theme.textStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.h,
                    ),
                    onChanged: searchFromAdress,
                    onTap: () {
                      homeNotifier.isWhere = false;
                      _onchange();
                    },
                  ),
                ),
                if (homeNotifier.isWhere == false)
                  InkWell(
                    onTap: () => homeNotifier.whereGoController.setText(''),
                    child: Padding(
                      padding: EdgeInsets.all(5.o),
                      child: SvgPicture.asset(
                        svgIcon.clear,
                        width: 14.o,
                        height: 14.o,
                      ),
                    ),
                  ),
                SizedBox(
                  width: 16.o,
                ),
              ],
            ),
          ),
          Container(
            width: 560.w,
            height: 0.7.o,
            color: theme.line,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
          ),
          Expanded(
            child: StreamBuilder<int>(
                stream: textStream,
                builder: (context, snapshot) {
                  int count = resultData.length < 5 ? resultData.length : 5;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List<Widget>.generate(
                        count,
                        (index) => InkWell(
                              onTap: () {
                                isHide = false;
                                Navigator.pop(context);
                                if (homeNotifier.isWhere == true) {
                                  homeNotifier.whereController
                                      .setText(resultData[index]);
                                } else {
                                  homeNotifier.whereGoController
                                      .setText(resultData[index]);
                                }
                                homeNotifier
                                    .getLocationFromaddress(resultData[index])
                                    .then((value) {
                                  if (value != null) {
                                    mapNotifier.moveToPosition(value);
                                    serviceCounter.isPositionChanget = true;
                                    serviceCounter.update();
                                    mapNotifier.centerPosition = value;
                                    if (homeNotifier.isWhere == true) {
                                      homeNotifier.whereController
                                          .setText(resultData[index]);
                                    } else {
                                      homeNotifier.whereGoController
                                          .setText(resultData[index]);
                                    }
                                  }
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.o,
                                  horizontal: 40.o,
                                ),
                                child: Text(
                                  resultData[index],
                                  style: theme.textStyle.copyWith(
                                    fontSize: 16.o,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            )),
                  );
                }),
          ),
          GestureDetector(
            onTap: () {
              isHide = false;
              serviceCounter.isWhereHide = homeNotifier.isWhere;
              mapNotifier.mapScrollstate.sink.add(false);
              Navigator.pop(context);
            },
            child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final notifier = ref.watch(servicesProvider);
              return Container(
                  height: 50.o,
                  width: 568.w,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: 16.o,
                    right: 16.o,
                    bottom: bottom + 10.o,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.o),
                      color: theme.cardBackground,
                      border: Border.all(
                        width: 2.o,
                        color: theme.yellow,
                      )),
                  child: Text(
                    selectMap.tr,
                    style: theme.textStyle.copyWith(
                      fontSize: 18.o,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                          .withOpacity(homeNotifier.streetLoading ? 0.5 : 1),
                    ),
                  ));
            }),
          ),
        ],
      ),
    );
  }

  void searchFromAdress(String address) async {
    final List<String> list = [];
    // avval lokal joy nomlariga tekshiradi agar yo'q bo'lsa keyin apiga murojat qiladi
    for (final place in serviceCounter.places) {
      if (place.name.toLowerCase().contains(address.toLowerCase())) {
        list.add(place.name);
        if (list.length == 5) {
          resultData.clear();
          resultData.addAll(list);
          controller.sink.add(resultData.length);
          return;
        }
      }
    }
    if (list.isNotEmpty) {
      resultData.clear();
      resultData.addAll(list);
      controller.sink.add(resultData.length);
      return;
    }
    MainModel mainModel = await client.get(
      Links.searchAdress + address,
      withoutHeader: true,
    );
    if (mainModel.data is List) {
      resultData = List<String>.from(
          mainModel.data.map((x) => x['description'].toString()));
      controller.sink.add(resultData.length);
    }
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
