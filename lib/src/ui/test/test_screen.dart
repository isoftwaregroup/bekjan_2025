// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:alo/src/network/http_result.dart';
// import 'package:alo/src/ui/home_page/models/marker_model.dart';
// import 'package:alo/src/ui/home_page/models/service_model.dart';
// import 'package:alo/src/variables/links.dart';
// import 'package:alo/src/variables/util_variables.dart';
// import 'package:alo/src/widgets/Toast.dart';
//
// import '../../helpers/apptheme.dart';
// import '../../network/client.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
//   List<LatLng> polyLine = [];
//   List<LatLng> driverLine = [];
//   double zoom = 14, bottom = 0;
//   List<String> searchedResults = [];
//   bool streetLoading = false;
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(40.385991, 71.779279),
//     zoom: 14.4746,
//   );
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   LatLng centerPosition = const LatLng(40.385991, 71.779279);
//   LatLng? myLocation;
//
//   BuildContext? dialogContext;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bottom = MediaQuery.of(context).viewInsets.bottom;
//     LatLng settedPosition = centerPosition;
//     return Scaffold(
//       backgroundColor: theme.secondary,
//       body: GoogleMap(
//         zoomGesturesEnabled: true,
//         myLocationEnabled: false,
//         zoomControlsEnabled: false,
//         mapType: MapType.normal,
//         markers: Set<Marker>.of(markers.values),
//         polylines: <Polyline>{
//           Polyline(
//             polylineId: const PolylineId('1'),
//             points: polyLine,
//             width: (3.o).toInt(),
//             color: isDark ? theme.blue : theme.mainBlue,
//           ),
//         },
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//         onCameraMove: (CameraPosition position) {},
//         onCameraMoveStarted: () {
//           //print('camera movie started');
//         },
//         onCameraIdle: () {},
//       ),
//     );
//   }
//
//   Future<void> _goToThePosition(CameraPosition position) async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(position));
//   }
//
//   void drawRoute(bool isUser, LatLng where, LatLng whereGo) async {
//     for (int i = 0; i < 3; i++) {
//       final MainModel result = await client.get(
//           '${Links.drawLink}?start=${where.longitude},${where.latitude}&end=${whereGo.longitude},${whereGo.latitude}');
//       try {
//         //distance = (result.data['distance'] is int) ? result.data['distance'] : 0;
//         //tarifs = List<TarifModel>.from(result.data['modes'].map((x) => TarifModel.fromJson(x)));
//         List list = result.data['ors']['features'] ?? [];
//         if (list.isNotEmpty) {
//           List<dynamic> coordinates = list.first['geometry']['coordinates'];
//           if (coordinates.isNotEmpty) {
//             final list = List<LatLng>.generate(
//                 coordinates.length,
//                 (index) =>
//                     LatLng(coordinates[index].last, coordinates[index].first));
//             if (isUser) {
//               polyLine = list;
//             } else {
//               driverLine = list;
//             }
//             setState(() {
//               streetLoading = false;
//             });
//             return;
//           }
//           final value = list.first['properties']['summary']['duration'];
//           if (value is int) {
//             //durationTime = value;
//           }
//         }
//       } catch (e) {
//         print(e);
//       }
//     }
//     setState(() {
//       streetLoading = false;
//     });
//   }
//
//   void showMessage(String message) {
//     toast(context: context, txt: message);
//   }
//
//   void setMapStyle() async {
//     final controller = await _controller.future;
//     if (isDark) {
//       controller.setMapStyle(darkMap);
//     } else {
//       controller.setMapStyle(lightMap);
//     }
//   }
//
//   void getCardata(LatLng position) async {
//     MainModel result = await client.get(
//       '${Links.getCars}?latitude=${position.latitude}&longitude=${position.longitude}&radius=600',
//     );
//     if (result.status == 200) {
//       if (result.data is List) {
//         for (final value in result.data) {
//           MarkerModel merkermodel = MarkerModel.fromJson(value);
//           if (merkermodel.latLng != null) {
//             markers[MarkerId(merkermodel.id)] = Marker(
//               markerId: MarkerId(merkermodel.id),
//               position: merkermodel.latLng!,
//               rotation: merkermodel.angle.toDouble(),
//               icon: car,
//             );
//           }
//         }
//         setState(() {});
//       }
//     } else {
//       show(result.message);
//     }
//   }
//
//   void show(String message) {
//     toast(context: context, txt: message);
//   }
// }
