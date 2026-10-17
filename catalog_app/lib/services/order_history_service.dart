import 'dart:convert';

import 'package:catalog_app/models/order_model.dart';
import 'package:catalog_app/services/local_storage_service.dart';

class OrderHistoryService {
  static const String _storageKey = 'order_history';

  OrderHistoryService({LocalStorageService? storage})
    : _storage = storage ?? LocalStorageService();

  final LocalStorageService _storage;

  Future<List<OrderRecord>> loadOrders() async {
    final storedOrders = await _storage.getStringList(_storageKey) ?? [];
    final orders = <OrderRecord>[];

    for (final storedOrder in storedOrders) {
      try {
        final decoded = jsonDecode(storedOrder);
        if (decoded is Map<String, dynamic>) {
          orders.add(OrderRecord.fromJson(decoded));
        }
      } on FormatException {
        continue;
      }
    }

    return orders;
  }

  Future<void> addOrder(OrderRecord order) async {
    final orders = await loadOrders();
    orders.insert(0, order);
    await _storage.saveStringList(
      _storageKey,
      orders.map((order) => jsonEncode(order.toJson())).toList(),
    );
  }
}
