import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class OrderController {
  static const String _key = 'saved_orders';

  Future<void> saveOrder(Order order) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Order> existingOrders = await loadOrders();
      existingOrders.insert(0, order); // Add new order at the top

      final List<String> encodedOrders = existingOrders
          .map((o) => json.encode(o.toJson()))
          .toList();

      await prefs.setStringList(_key, encodedOrders);
      print("Order saved successfully. Total count: ${existingOrders.length}");
    } catch (e) {
      print("Error saving order: $e");
    }
  }

  Future<List<Order>> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? encodedOrders = prefs.getStringList(_key);

      if (encodedOrders == null) {
        print("No saved orders found.");
        return [];
      }

      final List<Order> orders = encodedOrders
          .map((o) => Order.fromJson(json.decode(o)))
          .toList();

      print("Loaded orders count: ${orders.length}");
      return orders;
    } catch (e) {
      print("Error loading orders: $e");
      return [];
    }
  }
}
