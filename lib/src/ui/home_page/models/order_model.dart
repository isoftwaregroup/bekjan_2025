import 'package:app/src/ui/home_page/models/service_model.dart';

import 'marker_model.dart';

class OrderModel {
  OrderModel({
    required this.id,
    required this.mode_id,
    required this.latitude1,
    required this.longitude1,
    required this.latitude2,
    required this.longitude2,
    required this.address1,
    required this.address2,
    required this.cost,
    required this.datetime,
    required this.services,
    this.comment,
    required this.mode,
    required this.status,
    required this.type,
    required this.history,
  });

  String id;
  String mode_id;
  double latitude1;
  double longitude1;
  double latitude2;
  double longitude2;
  String address1;
  String address2;
  String cost;
  String? comment;
  String datetime;
  List<SericeModel> services;
  CarModel mode;
  CarModel status;
  CarModel type;
  HistoryModel? history;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] == null ? '' : json['id'].toString(),
        mode_id: json['mode_id'] == null ? '' : json['mode_id'].toString(),
        latitude1: double.tryParse(json['latitude1'].toString()) ?? 0,
        longitude1: double.tryParse(json['longitude1'].toString()) ?? 0,
        latitude2: double.tryParse(json['latitude2'].toString()) ?? 0,
        longitude2: double.tryParse(json['longitude2'].toString()) ?? 0,
        address1: json['address1'].toString(),
        address2: json['address2'].toString(),
        cost: json['cost'].toString(),
        datetime: json['created_at'] is Map<String, dynamic>
            ? json['created_at']['datetime'].toString()
            : '',
        comment: json['comment'] is String ? json['comment'] : null,
        services: json['services'] is List
            ? List<SericeModel>.from(
                json['services'].map((x) => SericeModel.fromJson(x)))
            : [],
        mode: CarModel.fromJson(json['mode'] ?? {}),
        status: CarModel.fromJson(json['status'] ?? {}),
        type: CarModel.fromJson(json['type'] ?? {}),
        history: json['history'] is Map<String, dynamic>
            ? HistoryModel.fromJson(json['history'])
            : null,
      );
}

class DriverModel {
  DriverModel({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.rating,
    required this.phone,
    required this.photo,
    required this.car,
    required this.location,
  });

  String id;
  String first_name;
  String last_name;
  String rating;
  String phone;
  String photo;
  CarModel car;
  MarkerModel location;

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        id: json['id'] == null ? '' : json['id'].toString(),
        first_name:
            json['first_name'] == null ? '' : json['first_name'].toString(),
        last_name:
            json['last_name'] == null ? '' : json['last_name'].toString(),
        rating: json['rating'] == null ? '' : json['rating'].toString(),
        phone: json['phone'] == null ? '' : json['phone'].toString(),
        photo: json['photo'] == null ? '' : json['photo'].toString(),
        car: CarModel.fromJson(json['car'] ?? {}),
        location: MarkerModel.fromJson(json['location'] ?? {})
            .copyWith(id: 'driverId'),
      );

  DriverModel copyWith({
    String? id,
    String? first_name,
    String? last_name,
    String? rating,
    String? phone,
    String? photo,
    CarModel? car,
    MarkerModel? location,
  }) {
    return DriverModel(
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      rating: rating ?? this.rating,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      car: car ?? this.car,
      location: location ?? this.location,
    );
  }
}

class HistoryModel {
  HistoryModel({
    required this.driver,
    required this.rating,
    required this.phone,
    required this.photo,
    required this.mode,
    required this.car,
    required this.location,
    required this.cost,
    required this.distance,
    required this.waitTime,
    required this.waitCost,
  });

  String driver;
  String rating;
  String phone;
  String photo;
  String cost;
  String distance;
  String waitTime;
  String waitCost;
  CarModel mode;
  CarModel car;
  MarkerModel location;

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        driver: json['driver'] == null ? '' : json['driver'].toString(),
        rating: json['rating'] == null ? '' : json['rating'].toString(),
        phone: json['phone'] == null ? '' : json['phone'].toString(),
        photo: json['photo'] == null ? '' : json['photo'].toString(),
        cost: json['cost'] == null ? '' : json['cost'].toString(),
        distance: json['distance'] == null ? '' : json['distance'].toString(),
        waitTime: json['wait_time'] == null ? '' : json['wait_time'].toString(),
        waitCost: json['wait_cost'] == null ? '' : json['wait_cost'].toString(),
        mode: CarModel.fromJson(json['mode'] ?? {}),
        car: CarModel.fromJson(json['car'] ?? {}),
        location: MarkerModel.fromJson(json['location'] ?? {})
            .copyWith(id: 'driverId'),
      );
}

class CarModel {
  CarModel({
    required this.name,
    required this.number,
    required this.colorName,
    required this.colorCode,
  });

  String name;
  String number;
  String colorName;
  String colorCode;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        name: json['name'] == null ? '' : json['name'].toString(),
        number: json['number'] == null ? '' : json['number'].toString(),
        colorName:
            json['color']?['name'] == null ? '' : '${json['color']?['name']}',
        colorCode:
            json['color']?['code'] == null ? '' : '${json['color']?['code']}',
      );
}
