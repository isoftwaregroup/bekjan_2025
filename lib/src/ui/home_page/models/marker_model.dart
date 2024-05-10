import 'package:maps_toolkit/maps_toolkit.dart';

class MarkerModel {
  MarkerModel({
    required this.id,
    required this.accuracy,
    this.latLng,
    required this.angle,
  });

  String id;
  int accuracy;
  int angle;
  LatLng? latLng;

  factory MarkerModel.fromJson(Map<String, dynamic> json) {
    double? lat = double.tryParse(json['latitude'].toString());
    double? lon = double.tryParse(json['longitude'].toString());
    LatLng? latLng;
    if (lat != null && lon != null) {
      latLng = LatLng(lat, lon);
    }
    return MarkerModel(
      id: json['id'] == null ? '' : json['id'].toString(),
      latLng: latLng,
      angle: int.tryParse(json['angle'].toString()) ?? 0,
      accuracy: int.tryParse(json['accuracy'].toString()) ?? 0,
    );
  }

  MarkerModel copyWith({
    String? id,
    int? accuracy,
    int? angle,
    LatLng? latLng,
  }) {
    return MarkerModel(
      id: id ?? this.id,
      accuracy: accuracy ?? this.accuracy,
      angle: angle ?? this.angle,
      latLng: latLng ?? this.latLng,
    );
  }
}
