import 'dart:convert';

import 'package:catalog_app/models/products_model.dart';
import 'package:catalog_app/services/local_storage_service.dart';

class CartManager {
  static final List<Data> cartItems = [];
  static const String _storageKey = 'cart_items';
  static final LocalStorageService _storage = LocalStorageService();

  static double get total {
    return cartItems.fold(0, (sum, product) {
      final price = product.price?.replaceAll(RegExp(r'[^0-9.]'), '');
      return sum + (double.tryParse(price ?? '') ?? 0);
    });
  }

  static Future<void> loadCart() async {
    final storedItems = await _storage.getStringList(_storageKey) ?? [];
    cartItems
      ..clear()
      ..addAll(
        storedItems.map((item) {
          try {
            return Data.fromJson(
              Map<String, dynamic>.from(jsonDecode(item) as Map),
            );
          } on FormatException {
            return null;
          } on TypeError {
            return null;
          }
        }).whereType<Data>(),
      );
  }

  static Future<void> addProduct(Data product) async {
    cartItems.add(product);
    await _saveCart();
  }

  static Future<void> removeProduct(int index) async {
    if (index < 0 || index >= cartItems.length) return;
    cartItems.removeAt(index);
    await _saveCart();
  }

  static Future<void> clearCart() async {
    cartItems.clear();
    await _saveCart();
  }

  static Future<void> _saveCart() async {
    final storedItems = cartItems
        .map((product) => jsonEncode(product.toJson()))
        .toList();
    await _storage.saveStringList(_storageKey, storedItems);
  }
}
