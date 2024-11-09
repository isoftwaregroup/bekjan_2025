import 'package:app/src/ui/home_page/models/order_model.dart';

class BonuseModel {
  BonuseModel({
    required this.id,
    required this.value,
    required this.datetime,
    required this.order,
    required this.reason,
    required this.type,
  });
  String id;
  int value;
  String datetime;
  OrderModel order;
  CarModel reason;
  CarModel type;

  factory BonuseModel.fromJson(Map<String, dynamic> json) => BonuseModel(
        id: json['id'] == null ? '' : json['id'].toString(),
        value: json['value'] is int ? json['value'] : 0,
        datetime: json['created_at'] is Map<String, dynamic>
            ? json['created_at']['datetime'].toString()
            : '',
        order: OrderModel.fromJson(json['order'] ?? {}),
        reason: CarModel.fromJson(json['reason'] ?? {}),
        type: CarModel.fromJson(json['type'] ?? {}),
      );
}
