import 'package:flutter/material.dart';
import 'package:catalog_app/models/order_model.dart';

class OrderHistoryItem extends StatelessWidget {
  const OrderHistoryItem({super.key, required this.order});

  final OrderRecord order;

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    final month = localDate.month.toString().padLeft(2, '0');
    final day = localDate.day.toString().padLeft(2, '0');
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');
    return '$day/$month/${localDate.year} · $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(vertical: 8),
      childrenPadding: const EdgeInsets.only(bottom: 16),
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFEAF2FF),
        child: Icon(Icons.receipt_long_outlined, color: Colors.blue),
      ),
      title: Text(
        'Order ${order.displayNumber}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${_formatDate(order.createdAt)} · ${order.items.length} items',
      ),
      trailing: Text(
        '\$${order.total.toStringAsFixed(2)}',
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Items',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(item.name, overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 12),
                      Text(item.price),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Delivery address',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(order.customerName),
              Text(order.deliveryAddress),
              Text(order.email),
              Text(order.phone),
            ],
          ),
        ),
      ],
    );
  }
}
