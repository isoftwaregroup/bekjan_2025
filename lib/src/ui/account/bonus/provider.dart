import 'package:app/src/network/client.dart';
import 'package:app/src/network/http_result.dart';
import 'package:app/src/ui/home_page/models/order_model.dart';
import 'package:app/src/variables/links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bonus_model.dart';

final bonusProvider = ChangeNotifierProvider<BonusNotifier>((ref) {
  return bonusNotifier;
});

BonusNotifier? _bonusNotifier;
BonusNotifier get bonusNotifier {
  _bonusNotifier ??= BonusNotifier();
  return _bonusNotifier!;
}

class BonusNotifier with ChangeNotifier {
  int page = 1;
  bool loading = false;

  List<BonuseModel> bonuses = [];

  Future<void> getMyBonuses(String from, String to) async {
    if (!loading) {
      loading = true;
      if (page == 1) {
        bonuses = [];
      }
      MainModel result = await client
          .get('${Links.bonusHistory}?from=$from&to=$to&page=$page');
      if (result.status == 200 && result.data['data'] is List) {
        final list = List<BonuseModel>.from(
            result.data['data'].map((x) => BonuseModel.fromJson(x)));
        if (list.isNotEmpty) {
          bonuses.addAll(list);
          page++;
          notifyListeners();
        }
      }
      loading = false;
    }
  }

  Future<void> setFullOrder(int index) async {
    if (bonuses[index % bonuses.length].order.comment == null) {
      MainModel result = await client.get(
          '${Links.getFullBonus}?id=${bonuses[index % bonuses.length].id}');
      if (result.status == 200) {
        bonuses[index % bonuses.length].order =
            OrderModel.fromJson(result.data['order'] ?? {});
        notifyListeners();
      } else {
        return Future.error(result.message);
      }
    }
  }

  void update() {
    notifyListeners();
  }
}
