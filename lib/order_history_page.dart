import 'package:flutter/material.dart';
import 'controllers/order_controller.dart';
import 'models/order.dart' as models;
import 'widgets/brand_logo.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatefulWidget {
  final bool isDarkMode;

  const OrderHistoryPage({super.key, required this.isDarkMode});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<models.Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final orderController = Provider.of<OrderController>(
      context,
      listen: false,
    );
    final orders = await orderController.loadOrders();
    setState(() {
      _orders = orders;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF1F8E9);
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final cardColor = widget.isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            const BrandLogo(height: 35),
            const SizedBox(width: 10),
            Text(
              "Order History",
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
          ],
        ),
        backgroundColor: widget.isDarkMode
            ? Colors.black
            : const Color(0xFF028A2B),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No orders yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Card(
                  color: cardColor,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      "Order #${DateFormat('yyyyMMdd').format(order.timestamp)}-${index + 1}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      "${DateFormat('MMM dd, yyyy HH:mm').format(order.timestamp)} | Rs. ${order.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(color: textColor.withOpacity(0.6)),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            Text(
                              "Items:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            ...order.items.map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${item.name} (${item.size}) x${item.quantity}",
                                      style: TextStyle(color: textColor),
                                    ),
                                    Text(
                                      "Rs. ${(item.price * item.quantity).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Shipping Address:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              "${order.address.firstName} ${order.address.lastName}\n${order.address.address}, ${order.address.city}",
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Payment Method: ${order.paymentMethod.toUpperCase()}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
