import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'cart_manager.dart';
import 'widgets/product_image.dart';
import 'widgets/brand_logo.dart';
import 'cart_page.dart';

// MAD2 Requirement: Redesigned Detail View with interactive Variants and Pricing
class ProductDetailPage extends StatefulWidget {
  final Product product;
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String _selectedSize = "12.5kg"; // Default size
  int _quantity = 1;

  final List<String> _sizes = ["900g", "12.5kg", "15kg"];

  // MAD2 Requirement: Deterministic pricing logic based on size variant
  double _calculateUnitPrice() {
    final basePrice = widget.product.price;
    if (_selectedSize == "900g")
      return double.parse((basePrice * 0.35).toStringAsFixed(2));
    if (_selectedSize == "15kg")
      return double.parse((basePrice * 1.15).toStringAsFixed(2));
    return basePrice; // 12.5kg is base
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartManager>(context, listen: false);
    final bgColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = widget.isDarkMode
        ? Colors.grey[400]
        : Colors.grey[600];

    final unitPrice = _calculateUnitPrice();
    final totalPrice = unitPrice * _quantity;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Row(
          children: [
            const BrandLogo(height: 35),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            Center(
              child: Container(
                width: 200,
                height: 230,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: widget.isDarkMode
                      ? const Color(0xFF1E1E1E)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ProductImage(
                      url: widget.product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _buildRatingRow(subTextColor!),
                  const SizedBox(height: 16),

                  _buildInfoRow("Availability:", "In stock", textColor),
                  _buildInfoRow(
                    "Product Type:",
                    widget.product.category ?? "General",
                    textColor,
                  ),
                  _buildInfoRow("SKU:", "WH-${widget.product.id}", textColor),

                  const Divider(height: 32),

                  Text(
                    widget.product.description ??
                        "Premium quality product for your pets.",
                    style: TextStyle(
                      fontSize: 15,
                      color: subTextColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // MAD2: Dynamic Price display based on Size
                  Text(
                    "Rs. ${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B9E4B),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "* Size",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: _sizes
                        .map((size) => _buildSizeChip(size))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Quantity:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildQuantityStepper(textColor),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // MAD2: Add to cart with correct Size and computed Unit Price
                        cart.addToCart(
                          CartItem(
                            name: widget.product.name,
                            image: widget.product.imageUrl,
                            size: _selectedSize,
                            price: unitPrice,
                            quantity: _quantity,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${widget.product.name} Added to cart!",
                            ),
                            backgroundColor: const Color(0xFF1B9E4B),
                          ),
                        );
                        // Navigate to Review Order (CartPage)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(
                              isDarkMode: widget.isDarkMode,
                              onToggleTheme: widget.onToggleTheme,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B9E4B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "ADD TO CART",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(Color textColor) {
    return Row(
      children: [
        ...List.generate(
          5,
          (index) => const Icon(Icons.star, color: Colors.amber, size: 20),
        ),
        const SizedBox(width: 8),
        Text("(4 reviews)", style: TextStyle(color: textColor, fontSize: 14)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeChip(String size) {
    bool isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = size),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B9E4B) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF1B9E4B) : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (widget.isDarkMode ? Colors.white : Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityStepper(Color textColor) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              if (_quantity > 1) setState(() => _quantity--);
            },
            icon: const Icon(Icons.remove, size: 20),
            color: textColor,
          ),
          Text(
            _quantity.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _quantity++),
            icon: const Icon(Icons.add, size: 20),
            color: textColor,
          ),
        ],
      ),
    );
  }
}
