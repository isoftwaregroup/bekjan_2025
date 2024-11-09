import 'package:app/src/network/client.dart';
import 'package:app/src/network/http_result.dart';
import 'package:app/src/variables/links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashProvider = ChangeNotifierProvider<SplashNotifier>((ref) {
  return splashNotifier;
});

SplashNotifier? _splashNotifier;
SplashNotifier get splashNotifier {
  _splashNotifier ??= SplashNotifier();
  return _splashNotifier!;
}

class SplashNotifier with ChangeNotifier {
  List<PageModel>? pages;
  bool permitLoading = false;

  Future<void> getSplash() async {
    MainModel result = await client.get(Links.splash);

    print("splashScreen ${result.title}");
    if (result.status == 200) {
      pages =
          List<PageModel>.from(result.data.map((x) => PageModel.fromJson(x)));
      if (pages!.isEmpty) {
        return Future.error(result.message);
      }
      notifyListeners();
    } else {
      return Future.error(result.message);
    }
  }

  void update() {
    notifyListeners();
  }
}

class PageModel {
  PageModel({
    required this.title,
    required this.description,
    required this.photo,
  });

  String title, description, photo;

  factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
        title: json["title"].toString(),
        description: json["description"].toString(),
        photo: json["photo"].toString(),
      );
}
