
class MainModel {
  MainModel({
    required this.status,
    required this.message,
    this.title = '',
    this.key = '',
    this.data,
    this.error,
    this.step = 1,
  });

  int status,step;
  String message,key,title;
  dynamic data,error;

  factory MainModel.fromJson(Map<String, dynamic> json) => MainModel(
    status: json["status"] ?? 403,
    message: json["message"].toString(),
    title: json["title"].toString(),
    key: json["key"].toString(),
    data: json["data"],
    error: json["error"],
    step: (json["step"] is int) ? json["step"] : 1,
  );

  MainModel copyWith({
    int? status,
    String? message,
    String? title,
    String? key,
    dynamic data,
    dynamic error,
  }){
    return MainModel(
      status: status ?? this.status,
      message: message ?? this.message,
      title: title ?? this.title,
      key: key ?? this.key,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}
