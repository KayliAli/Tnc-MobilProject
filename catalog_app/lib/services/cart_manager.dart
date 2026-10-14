import 'package:catalog_app/models/products_model.dart';

class CartManager {
  static final List<Data> cartItems = [];

  static void addProduct(Data product) {
    cartItems.add(product);
  }

  static void removeProduct(int index) {
    cartItems.removeAt(index);
  }

  static void clearCart() {
    cartItems.clear();
  }
}