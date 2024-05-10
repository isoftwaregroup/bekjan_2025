class SericeModel {
  SericeModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.icon,
    this.isActive = false,
  });

  String id;
  String name;
  int cost;
  String icon;
  bool isActive;

  factory SericeModel.fromJson(Map<String, dynamic> json) => SericeModel(
        id: json['id'] == null ? '' : json['id'].toString(),
        name: json['name'] == null ? '' : json['name'].toString(),
        cost: int.tryParse(json['cost'].toString()) ?? 0,
        icon: json['icon'] == null ? '' : json['icon'].toString(),
      );

  SericeModel copyWith({
    String? id,
    String? name,
    int? cost,
    String? icon,
    bool? isActive,
  }) {
    return SericeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
    );
  }
}
