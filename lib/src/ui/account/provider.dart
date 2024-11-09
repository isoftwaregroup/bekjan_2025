import 'package:app/src/network/client.dart';
import 'package:app/src/network/http_result.dart';
import 'package:app/src/ui/account/app_info.dart';
import 'package:app/src/ui/auth/model/user.dart';
import 'package:app/src/variables/links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

ChangeNotifierProvider<UserNotifier> userProvider =
    ChangeNotifierProvider<UserNotifier>((ref) {
  return userNotifier;
});
UserNotifier? _userNotifier;
UserNotifier get userNotifier {
  _userNotifier ??= UserNotifier();
  return _userNotifier!;
}

class UserNotifier with ChangeNotifier {
  UserNotifier() : super() {
    //getUser();
  }

  User? user;
  AboutUs? aboutData;
  List<FAQModel> faqs = [];
  String totalBonus = '';
  String shareMsg = '';

  void setUser(User? settedUser) async {
    user = settedUser;
    notifyListeners();
  }

  Future<dynamic> getUser() async {
    MainModel result = await client.get(Links.getMe);
    if (result.status == 200) {
      user = User.fromJson(result.data);
      notifyListeners();
      return user;
    } else {
      notifyListeners();
      return result;
    }
  }

  Future<void> getTotalBonus() async {
    MainModel result = await client.get(Links.totalBonus);
    if (result.status == 200) {
      totalBonus = result.data.toString();
      update();
    } else {}
  }

  Future<void> getContactUs() async {
    MainModel result = await client.get(Links.getMe);
    if (result.status == 200) {
      user = User.fromJson(result.data);
      notifyListeners();
    } else {
      user = User.fromJson({});
      notifyListeners();
    }
  }

  Future<AboutUs?> getAboutUs() async {
    if (aboutData == null) {
      MainModel result = await client.get(Links.about);
      if (result.status == 200) {
        final AboutUs aboutUs = AboutUs.fromJson(result.data);
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        aboutData = aboutUs.copyWith(
            name: packageInfo.appName, version_name: packageInfo.version);
        notifyListeners();
      }
    }
    return aboutData;
  }

  Future<void> getFAQ() async {
    MainModel result = await client.get(Links.faq);
    if (result.status == 200 && result.data is List) {
      faqs = List<FAQModel>.from(result.data.map((x) => FAQModel.fromJson(x)));
      notifyListeners();
    }
  }

  void update() {
    notifyListeners();
  }

  void getShareMsg() => client.get(Links.shareMessage).then((result) {
        if (result.data is Map<String, dynamic>) {
          shareMsg = result.data['message'];
        }
      });
}

class FAQModel {
  FAQModel({
    required this.answer,
    required this.question,
  });

  String answer, question;

  factory FAQModel.fromJson(Map<String, dynamic> json) => FAQModel(
        answer: json["answer"].toString(),
        question: json["question"].toString(),
      );
}
