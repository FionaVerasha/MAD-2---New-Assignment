import '../models/product.dart';
import '../services/product_service.dart';

class ProductController {
  final ProductService _productService = ProductService();

  Future<List<Product>> fetchProducts() async {
    return await _productService.fetchProducts();
  }

  List<Product> filterProducts(
    List<Product> products,
    String categorySlug,
    String searchQuery,
  ) {
    var filtered = products;
    if (categorySlug != "all") {
      filtered = filtered.where((p) => p.category == categorySlug).toList();
    }
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }
    return filtered;
  }
}
