import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import 'api_client.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();
  static const String _offlineProductsPath =
      'assets/data/products_offline.json';

  // MAD2 Requirement: Fetching data from an external JSON source (SSP2 Backend)
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _apiClient.dio.get('/api/products');

      // Laravel sometimes wraps lists in 'data' key
      final List<dynamic> data = response.data is Map
          ? response.data['data']
          : response.data;

      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint(
        'Product API failed, loading offline JSON fallback: ${e.message}',
      );
      return _fetchOfflineProducts();
    }
  }

  Future<List<Product>> _fetchOfflineProducts() async {
    final jsonString = await rootBundle.loadString(_offlineProductsPath);
    final List<dynamic> data = json.decode(jsonString);
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> fetchProduct(int id) async {
    try {
      final response = await _apiClient.dio.get('/api/products/$id');
      final dynamic data = response.data is Map
          ? (response.data['data'] ?? response.data)
          : response.data;
      return Product.fromJson(data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Failed to load product details";
    }
  }
}
