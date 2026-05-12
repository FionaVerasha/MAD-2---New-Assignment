import 'package:dio/dio.dart';
import '../models/product.dart';
import 'api_client.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();

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
      throw e.response?.data['message'] ?? "Failed to load products";
    }
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
