import '../utils/url_utils.dart';

// Product model parsed from external JSON
class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? image;
  final String? category;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle price parsing safely as it could be String or num from API
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      if (json['price'] is num) {
        parsedPrice = json['price'].toDouble();
      } else {
        // Try parsing from string (e.g. "Rs. 2500" or "2500")
        final match = RegExp(
          r'([0-9]+(?:\.[0-9]+)?)',
        ).firstMatch(json['price'].toString());
        if (match != null) {
          parsedPrice = double.tryParse(match.group(1)!) ?? 0.0;
        }
      }
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['title'] ?? 'Unknown Product',
      description: json['description'],
      price: parsedPrice,
      image: json['image'] ?? json['image_url'],
      category: json['category'] is Map
          ? json['category']['name']
          : json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
    };
  }

  String get imageUrl => resolveImageUrl(image);
}
