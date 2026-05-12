import '../cart_manager.dart';

class CheckoutSnapshot {
  final List<CartItem> items;
  final double totalAmount;
  final DateTime createdAt;

  CheckoutSnapshot({
    required this.items,
    required this.totalAmount,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items
          .map(
            (i) => {
              'name': i.name,
              'image': i.image,
              'size': i.size,
              'price': i.price,
              'quantity': i.quantity,
            },
          )
          .toList(),
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CheckoutSnapshot.fromJson(Map<String, dynamic> json) {
    return CheckoutSnapshot(
      items: (json['items'] as List)
          .map(
            (i) => CartItem(
              name: i['name'],
              image: i['image'],
              size: i['size'],
              price: i['price'].toDouble(),
              quantity: i['quantity'],
            ),
          )
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
