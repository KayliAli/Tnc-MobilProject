import 'package:flutter/material.dart';
import 'package:catalog_app/components/product_card.dart';
import 'package:catalog_app/services/api_service.dart';
import 'package:catalog_app/services/local_storage_service.dart';
import 'package:catalog_app/models/products_model.dart';
import 'package:catalog_app/views/login_screen.dart';
import 'package:catalog_app/views/products_detail_screen.dart';
import 'package:catalog_app/views/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<Data> allProducts = [];
  String _searchQuery = '';

  bool isLoading = false;
  String errorMessage = '';

  Future<void> loadProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
      final Products products = await apiService.fetchProducts();
      if (!mounted) return;
      setState(() {
        allProducts = products.data ?? [];
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await LocalStorageService().clearData('is_logged_in');
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Text(
                'Discover the World of Flutter',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Explore our catalog of products and services.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Arama Çubuğu
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) =>
                      setState(() => _searchQuery = value.trim()),
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Banner
              Image.network(
                "https://wantapi.com/assets/banner.png",
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 80,
                  child: Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
              const SizedBox(height: 16),

              // Ürün Listesi
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Hata: $errorMessage',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: loadProducts,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _filteredProducts.isEmpty
                    ? Center(
                        child: Text(
                          _searchQuery.isEmpty
                              ? 'No products available'
                              : 'No products found',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.75,
                            ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];

                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsScreen(product: product),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Data> get _filteredProducts {
    if (_searchQuery.isEmpty) return allProducts;
    final query = _searchQuery.toLowerCase();
    return allProducts.where((product) {
      return (product.name ?? '').toLowerCase().contains(query) ||
          (product.tagline ?? '').toLowerCase().contains(query) ||
          (product.description ?? '').toLowerCase().contains(query);
    }).toList();
  }
}
