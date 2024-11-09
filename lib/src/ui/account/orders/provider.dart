import 'package:app/src/network/client.dart';
import 'package:app/src/network/http_result.dart';
import 'package:app/src/ui/home_page/models/order_model.dart';
import 'package:app/src/variables/links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderProvider = ChangeNotifierProvider<OrderNotifier>((ref) {
  return orderNotifier;
});

OrderNotifier? _orderNotifier;
OrderNotifier get orderNotifier {
  _orderNotifier ??= OrderNotifier();
  return _orderNotifier!;
}

class OrderNotifier with ChangeNotifier {
  bool loading = false;

  List<OrderModel> orders = [];

  int page = 1, pageCount = 2;
  Future<void> getMyOrders(String from, String to) async {
    if (!loading && (page == 1 || pageCount >= page)) {
      loading = true;
      if (page == 1) {
        orders = [];
      }
      MainModel result =
          await client.get('${Links.history}?from=$from&to=$to&page=$page');
      if (result.status == 200 && result.data['data'] is List) {
        final list = List<OrderModel>.from(
            result.data['data'].map((x) => OrderModel.fromJson(x)));
        if (list.isNotEmpty) {
          orders.addAll(list);
          page++;
          notifyListeners();
          try {
            pageCount = result.data['_meta']['pageCount'];
          } catch (e) {}
        }
      }
      loading = false;
    }
  }

  void setFullOrder(int index) async {
    if (orders[index % orders.length].comment == null) {
      MainModel result = await client.get(
          '${Links.historyOrder}?order_id=${orders[index % orders.length].id}');
      if (result.status == 200) {
        orders[index % orders.length] = OrderModel.fromJson(result.data);
        notifyListeners();
      }
    }
  }

  void update() {
    notifyListeners();
  }
}
