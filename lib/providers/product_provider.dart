import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';

class ProductProvider extends ChangeNotifier {
  final ProductController _productController = ProductController();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _productController.fetchProducts();

      // Debug logging for first 5 products
      for (var i = 0; i < _products.length && i < 5; i++) {
        final p = _products[i];
        debugPrint(
          "DEBUG PRODUCT ${i + 1}: RAW: ${p.image} -> RESOLVED: ${p.imageUrl}",
        );
      }

      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  Product? findById(int id) {
    try {
      return _products.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }
}
