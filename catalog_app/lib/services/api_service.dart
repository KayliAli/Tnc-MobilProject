import 'dart:convert';
import 'package:catalog_app/models/products_model.dart';
import 'package:http/http.dart' as http;

class ApiService{

  Future<Products> fetchProducts() async {
    final response = await http.get(Uri.parse('https://wantapi.com/products.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Products.fromJson(data);
    } else {
      throw Exception('failed to load products');
    }
  }
}