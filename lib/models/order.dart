import '../cart_manager.dart';
import 'shipping_address.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final ShippingAddress address;
  final String paymentMethod;
  final DateTime timestamp;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.address,
    required this.paymentMethod,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'address': {
        'firstName': address.firstName,
        'lastName': address.lastName,
        'address': address.address,
        'city': address.city,
        'state': address.state,
        'postalCode': address.postalCode,
        'country': address.country,
        'phoneNumber': address.phoneNumber,
      },
      'paymentMethod': paymentMethod,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
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
      address: ShippingAddress(
        firstName: json['address']['firstName'],
        lastName: json['address']['lastName'],
        address: json['address']['address'],
        city: json['address']['city'],
        state: json['address']['state'],
        postalCode: json['address']['postalCode'],
        country: json['address']['country'],
        phoneNumber: json['address']['phoneNumber'],
      ),
      paymentMethod: json['paymentMethod'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
