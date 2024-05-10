class PlaceModel {
  PlaceModel({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  String name;
  double latitude;
  double longitude;

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
        name: json['name'] == null ? '' : json['name'].toString(),
        latitude: double.tryParse(json['latitude'].toString()) ?? 0,
        longitude: double.tryParse(json['longitude'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
