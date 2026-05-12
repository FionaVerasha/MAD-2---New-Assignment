import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'shipping_address_page.dart';
import 'widgets/product_image.dart';
import 'widgets/brand_logo.dart';
import 'models/checkout_snapshot.dart';
import 'services/checkout_storage.dart';

class CartPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const CartPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);

    //Dark mode colors
    final backgroundColor = isDarkMode
        ? const Color(0xFF1B5E20)
        : const Color(0xFFF1F8E9);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final accentColor = isDarkMode
        ? Colors.greenAccent[700]!
        : const Color(0xFF028A2B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            const BrandLogo(height: 35),
            const SizedBox(width: 10),
            const Text(
              "Your Cart",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          //Theme toggle button
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDarkMode
                ? "Switch to Light Mode"
                : "Switch to Dark Mode",
            onPressed: () => onToggleTheme(!isDarkMode),
          ),
        ],
      ),

      body: cartManager.items.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, color: textColor),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildStepper(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartManager.items.length,
                    itemBuilder: (context, index) {
                      final item = cartManager.items[index];
                      return Card(
                        color: cardColor,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Product Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ProductImage(
                                  url: item.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Size: ${item.size}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Rs. ${item.price.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Quantity controls  , delete
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_circle_outline,
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                    onPressed: () =>
                                        cartManager.decreaseQuantity(item),
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.add_circle_outline,
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                    onPressed: () =>
                                        cartManager.increaseQuantity(item),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        cartManager.removeItem(item),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Total Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: cardColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "Rs. ${cartManager.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkout button
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (cartManager.items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Your cart is empty!",
                              style: TextStyle(color: textColor),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).appBarTheme.backgroundColor,
                          ),
                        );
                      } else {
                        // Create and save snapshot for local persistence
                        final snapshot = CheckoutSnapshot(
                          items: List.from(cartManager.items),
                          totalAmount: cartManager.totalPrice,
                          createdAt: DateTime.now(),
                        );
                        await CheckoutStorage().saveSnapshot(snapshot);

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShippingAddressPage(
                                isDarkMode: isDarkMode,
                                onToggleTheme: onToggleTheme,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      "Proceed to Checkout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStep("Review", true, false),
        _buildLine(false),
        _buildStep("Address", false, false),
        _buildLine(false),
        _buildStep("Confirm", false, false),
      ],
    );
  }

  Widget _buildStep(String label, bool isActive, bool isComplete) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isComplete
                ? const Color(0xFF028A2B)
                : (isActive ? const Color(0xFF028A2B) : Colors.grey[300]),
            shape: BoxShape.circle,
          ),
          child: isComplete
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF028A2B) : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFF028A2B) : Colors.grey[300],
        margin: const EdgeInsets.only(bottom: 20),
      ),
    );
  }
}
