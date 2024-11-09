import 'package:app/src/helpers/dialogs.dart';
import 'package:app/src/helpers/widgets.dart';
import 'package:app/src/ui/account/account.dart';
import 'package:app/src/ui/account/provider.dart';
import 'package:app/src/ui/home_page/provider/home_provider.dart';
import 'package:app/src/ui/home_page/provider/map_provider.dart';
import 'package:app/src/ui/home_page/provider/service_provider.dart';
import 'package:app/src/ui/home_page/util.dart';
import 'package:app/src/ui/home_page/widgets/call_dispecher_screen.dart';
import 'package:app/src/ui/home_page/widgets/load_order.dart';
import 'package:app/src/ui/home_page/widgets/location_checker.dart';
import 'package:app/src/ui/home_page/widgets/map.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/ConnectionListner.dart';
import '../../helpers/apptheme.dart';
import '../../network/client.dart';
import '../../network/http_result.dart';
import '../../variables/links.dart';
import '../../variables/util_variables.dart';
import '../../widgets/Toast.dart';
import 'dialog/bottom_dialog.dart';
import 'dialog/bottom_tools_dialog.dart';
import 'dialog/set_rating.dart';
import 'models/order_model.dart';
import 'provider/driver_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int durationTime = -1, distance = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    homeNotifier.homeContext = () {
      return context;
    };
    if (mapNotifier.currentPosition != null) {
      homeNotifier.setStreet(mapNotifier.currentPosition!).then((value) {
        if (value != null) {
          homeNotifier.whereController.text = value;
          mapNotifier.currentPositionTitle = value;
        }
      });
    }
    checkStatus(true);
    connectionListner.homeConnectionListner = (isConnected) {
      isOnline = isConnected;
      if (isOnline) {
        setDispacherLink();
      }
    };
    userNotifier.getAboutUs().then((value) {
      PackageInfo.fromPlatform().then((packageInfo) {
        if ((value?.version ?? 1) >
            (int.tryParse(packageInfo.buildNumber) ?? 1)) {
          showCenterdialog(
            MessageDialog(
              msg: newVersion.tr,
              buttonTxt: update.tr,
              onTap: () async {
                if (!await launchUrl(
                    Uri.parse(
                        'https://play.google.com/store/apps/details?id=${packageInfo.packageName}'),
                    mode: LaunchMode.externalApplication)) {
                  throw 'Could not launch $num';
                }
              },
            ),
            context,
          );
        }
      });
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.resumed) {
      checkStatus(false);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (mapNotifier.googleMap != null) {
      mapNotifier.googleMap!.dispose();
    }
    super.dispose();
  }

  ScrollPhysics physics = const AlwaysScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) {
    final b = MediaQuery.of(context).viewInsets.bottom;
    if (bottom != b) {
      bottom = b;
      Future.delayed(const Duration(milliseconds: 10))
          .then((value) => serviceCounter.update());
    }
    return Scaffold(
      backgroundColor: theme.secondary,
      resizeToAvoidBottomInset: false,
      body: isOnline
          ? Consumer(
              builder: (context, ref, child) {
                final notifier = ref.watch(homeProvider);
                return PopScope(
                  canPop: canPop(),
                  onPopInvoked: (didPop) {
                    if (canPop()) return;
                    notifier.whereGoController.setText('');
                    mapNotifier.markers.clear();
                    notifier.isWhere = true;
                    mapNotifier.route.clear();
                    serviceCounter.isWhereHide = null;
                    mapNotifier.mapScrollstate.sink.add(false);
                    mapNotifier.update();
                    homeNotifier.update();
                  },
                  child: Stack(
                    children: [
                      const MapScreen(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SafeArea(
                          child: GestureDetector(
                            onTap: () => push(context, const AccountScreen()),
                            child: StreamBuilder<bool>(
                                stream: mapNotifier.mapScrollStream,
                                builder: (context, snapshot) {
                                  return AnimatedOpacity(
                                    opacity: snapshot.data == true ? 0 : 1,
                                    duration: const Duration(milliseconds: 250),
                                    child: Container(
                                      height: 36.o,
                                      width: 36.o,
                                      margin: EdgeInsets.only(
                                          left: 12.o, top: 12.o),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.o),
                                          color: theme.mainBlue),
                                      child: SvgPicture.asset(
                                        svgIcon.menu,
                                        width: 22.o,
                                        height: 22.o,
                                        colorFilter: const ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                      if (notifier.conditionKey.isEmpty &&
                          notifier.isWhere != null)
                        const LocationChecker(),
                      if (homeNotifier.conditionKey == 'order_initial')
                        const LoadOrder(),
                      if (homeNotifier.conditionKey.isEmpty)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  mapNotifier.zoom = 17;
                                  mapNotifier.moveToMyPosition();
                                },
                                child: Container(
                                  width: 50.o,
                                  height: 50.o,
                                  margin: EdgeInsets.only(
                                    right: 12.o,
                                    bottom: 15.o,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.o),
                                    color: theme.mainBlue,
                                  ),
                                  child: SvgPicture.asset(
                                    svgIcon.geolocator,
                                    height: 26.o,
                                    width: 26.o,
                                  ),
                                ),
                              ),
                              BottomToolsdialog(),
                            ],
                          ),
                        ),
                      if (homeNotifier.conditionKey == 'order_accepted' ||
                          homeNotifier.conditionKey == 'car_location' ||
                          homeNotifier.conditionKey == 'order_started' ||
                          homeNotifier.conditionKey == 'order_driver_arrived')
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BottomDialog(
                              data: notifier.driverModel ??
                                  DriverModel.fromJson({}),
                              onCancelOrder: () {
                                deleteServices();
                                deleteLastorder();
                                // socket.d();
                                setState(() {
                                  homeNotifier.conditionKey = '';
                                });
                                notifier.driverModel = null;
                              },
                            )
                          ],
                        ),
                    ],
                  ),
                );
              },
            )
          : const CallDispecherScreen(),
    );
  }

  void showMessage(String message) {
    toast(context: context, txt: message);
  }

  void checkStatus(bool isEnter) async {
    final Map<String, dynamic> data = getCurrentOrder();
    if (data['latitude1'] != null) {
      MainModel result = await client.post(Links.status);
      if (result.step == 0) {
        deleteServices();
        deleteLastorder();
      } else if (result.step == 5) {
        deleteServices();
        deleteLastorder();
        if (homeNotifier.conditionKey != 'order_completed' && isEnter) {
          showBottomDialog(
            RatingDialog(
              data: result.data,
            ),
            context,
          );
        }
      } else {
        if (result.step == 4) {
          String key = '';
          try {
            key = result.data['status']['number'].toString();
          } catch (e) {}
          if (key == '1' && homeNotifier.conditionKey != 'order_accepted') {
            homeNotifier.conditionKey = 'order_accepted';
            homeNotifier.driverModel = DriverModel.fromJson(result.data);
          } else if (key == '2' &&
              homeNotifier.conditionKey != 'order_driver_arrived') {
            homeNotifier.conditionKey = 'order_driver_arrived';
          } else if (key == '3' &&
              homeNotifier.conditionKey != 'order_started') {
            homeNotifier.conditionKey = 'order_started';
            driverCounter.setIsStart(homeNotifier.conditionKey);
            homeNotifier.driverModel = DriverModel.fromJson(result.data);
          }
        } else if (result.step == 1) {
          if (homeNotifier.conditionKey != 'order_initial') {
            homeNotifier.conditionKey = 'order_initial';
          }
        }
        // socket.init();
        // socket.listen(homeNotifier.listenSocket);
        // socket.onReconnect = homeNotifier.onReconnect;
        double? lat = double.tryParse(data['latitude1'].toString());
        double? lon = double.tryParse(data['longitude1'].toString());
        String title = data['address1'].toString();
        double? lat1 = double.tryParse(data['latitude2'].toString());
        double? lon1 = double.tryParse(data['longitude2'].toString());
        String title1 = data['address1'].toString();
        if (lat != null && lon != null) {
          mapNotifier.setMarker(Marker(
            markerId: homeNotifier.whereId,
            position: LatLng(lat, lon),
            icon: startMarker,
          ));
          homeNotifier.isWhere = null;
          homeNotifier.whereController.setText(title);
        }
        if (lat1 != null && lon1 != null) {
          mapNotifier.setMarker(Marker(
            markerId: homeNotifier.whereGoId,
            position: LatLng(lat1, lon1),
            icon: endMarker,
          ));
          homeNotifier.whereGoController.setText(title1);
          homeNotifier.isWhere = null;
        }
        setState(() {});
      }
    }
  }

  bool canPop() =>
      serviceCounter.isWhereHide == null &&
      mapNotifier.markers[homeNotifier.whereGoId] == null;
}
