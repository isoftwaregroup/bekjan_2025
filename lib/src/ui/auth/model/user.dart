class User {
  User({
    required this.id,
    required this.phone,
    required this.firstname,
    required this.lastname,
    required this.auth_key,
    required this.photo,
    required this.born,
    required this.gender,
    required this.type,
    required this.status,
    required this.step,
    required this.is_completed,
  });
  String id, phone, firstname, lastname, auth_key, photo, born;
  StrInt gender, type, status, step, is_completed;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] == null ? '' : json['id'].toString(),
        phone: json['phone'] == null ? '' : json['phone'].toString(),
        firstname:
            json['first_name'] == null ? '' : json['first_name'].toString(),
        lastname: json['last_name'] == null ? '' : json['last_name'].toString(),
        photo: json['photo'] == null ? '' : json['photo'].toString(),
        born: json['born'] == null ? '' : json['born'].toString(),
        auth_key: json['auth_key'] == null ? '' : json['auth_key'].toString(),
        gender: StrInt.fromJson(json['gender'] ?? {}),
        type: StrInt.fromJson(json['type'] ?? {}),
        status: StrInt.fromJson(json['status'] ?? {}),
        step: StrInt.fromJson(json['step'] ?? {}),
        is_completed: StrInt.fromJson(json['is_completed'] ?? {}),
      );
}

class StrInt {
  StrInt({
    required this.intVal,
    required this.string,
  });
  int intVal;
  String string;

  factory StrInt.fromJson(Map<String, dynamic> json) => StrInt(
        intVal: json['int'] is int ? json['int'] : -1,
        string: json['string'] is String ? json['string'] : '',
      );
}
