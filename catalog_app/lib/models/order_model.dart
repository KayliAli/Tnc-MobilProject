class OrderItem {
  const OrderItem({required this.name, required this.price, this.productId});

  final String name;
  final String price;
  final int? productId;

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'productId': productId,
  };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    name: json['name'] as String? ?? 'Product',
    price: json['price'] as String? ?? '',
    productId: json['productId'] as int?,
  );
}

class OrderRecord {
  const OrderRecord({
    required this.id,
    required this.createdAt,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.deliveryAddress,
    required this.total,
    required this.items,
  });

  final String id;
  final DateTime createdAt;
  final String customerName;
  final String email;
  final String phone;
  final String deliveryAddress;
  final double total;
  final List<OrderItem> items;

  String get displayNumber {
    final numericId = int.tryParse(id);
    final shortId = numericId == null
        ? id.toUpperCase()
        : numericId.toRadixString(36).toUpperCase();
    return 'ORD-$shortId';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'customerName': customerName,
    'email': email,
    'phone': phone,
    'deliveryAddress': deliveryAddress,
    'total': total,
    'items': items.map((item) => item.toJson()).toList(),
  };

  factory OrderRecord.fromJson(Map<String, dynamic> json) => OrderRecord(
    id: json['id'] as String? ?? '',
    createdAt:
        DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    customerName: json['customerName'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    deliveryAddress: json['deliveryAddress'] as String? ?? '',
    total: (json['total'] as num?)?.toDouble() ?? 0,
    items: (json['items'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(OrderItem.fromJson)
        .toList(),
  );
}
