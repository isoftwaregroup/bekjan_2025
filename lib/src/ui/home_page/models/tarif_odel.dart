class TarifModel {
  TarifModel({
    required this.id,
    required this.name,
    required this.img,
    required this.info,
    required this.value,
  });

  String id;
  String name;
  String img;
  String info;
  int value;

  factory TarifModel.fromJson(Map<String, dynamic> json) => TarifModel(
        id: json['id'] == null ? '' : json['id'].toString(),
        name: json['name'] == null ? '' : json['name'].toString(),
        img: json['img'] == null ? '' : json['img'].toString(),
        info: json['info'] == null ? '' : json['info'].toString(),
        value: int.tryParse(json['value'].toString()) ?? 0,
      );
}
