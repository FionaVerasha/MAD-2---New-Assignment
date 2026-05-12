import 'package:flutter/material.dart';
import 'cart_manager.dart';
import 'package:provider/provider.dart';
import 'providers/checkout_provider.dart';
import 'models/payment_method.dart';
import 'payment_page.dart';
import 'models/checkout_snapshot.dart';
import 'services/checkout_storage.dart';
import 'controllers/order_controller.dart';
import 'models/order.dart' as models;
import 'widgets/brand_logo.dart';

class CheckoutPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const CheckoutPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CheckoutSnapshot? _snapshot;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSnapshot();
  }

  Future<void> _loadSnapshot() async {
    final snapshot = await CheckoutStorage().loadSnapshot();
    if (mounted) {
      setState(() {
        _snapshot = snapshot;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final cartManager = Provider.of<CartManager>(context);
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    final address = checkoutProvider.address;

    // Use snapshot items if available, else fallback to cartManager (live cart)
    final items = _snapshot?.items ?? cartManager.items;
    final totalPrice = _snapshot?.totalAmount ?? cartManager.totalPrice;

    final backgroundColor = widget.isDarkMode
        ? const Color(0xFF121212)
        : Colors.grey[200];
    final cardColor = widget.isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final accentColor = widget.isDarkMode
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
              "Confirm Order",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepper(),
            const SizedBox(height: 24),
            Text(
              "Shipping to",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${address.firstName} ${address.lastName}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.address,
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                  Text(
                    "${address.city}, ${address.state} ${address.postalCode}",
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                  Text(
                    address.country,
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Phone: ${address.phoneNumber}",
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) {
              return Card(
                color: cardColor,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Color(0xFF028A2B),
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  subtitle: Text(
                    "Qty: ${item.quantity} | Size: ${item.size}",
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                  trailing: Text(
                    "Rs. ${(item.price * item.quantity).toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    "Rs. ${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "PAYMENT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "ALL TRANSACTIONS ARE SECURE AND ENCRYPTED.",
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.5),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildPaymentOption(
                    context,
                    method: PaymentMethod.cod,
                    title: "Cash on Delivery",
                    subtitle: "PAY WHEN YOU RECEIVE YOUR ORDER",
                    icon: Icons.money,
                    checkoutProvider: checkoutProvider,
                    textColor: textColor,
                  ),
                  const Divider(height: 1),
                  _buildPaymentOption(
                    context,
                    method: PaymentMethod.card,
                    title: "Bank Card / Bank Account – PayHere",
                    subtitle: "PAY USING CREDIT/DEBIT CARD",
                    icon: Icons.credit_card,
                    checkoutProvider: checkoutProvider,
                    textColor: textColor,
                  ),
                  const Divider(height: 1),
                  _buildPaymentOption(
                    context,
                    method: PaymentMethod.bankDeposit,
                    title: "Bank Deposit",
                    subtitle: "TRANSFER FUNDS DIRECTLY TO OUR BANK ACCOUNT",
                    icon: Icons.account_balance,
                    checkoutProvider: checkoutProvider,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () async {
                // Stripe dialog appears ONLY when pressing Place Order with Card payment selected
                if (checkoutProvider.selectedPaymentMethod ==
                    PaymentMethod.card) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaymentPage()),
                  );
                } else {
                  // COD or Bank Deposit flow
                  // Save order to history using MVC Controller
                  final orderController = Provider.of<OrderController>(
                    context,
                    listen: false,
                  );
                  final order = models.Order(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    items: items,
                    totalAmount: totalPrice,
                    address: address,
                    paymentMethod: checkoutProvider.selectedPaymentMethod.name,
                    timestamp: DateTime.now(),
                  );
                  await orderController.saveOrder(order);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Order Placed Successfully!"),
                        backgroundColor: Color(0xFF028A2B),
                      ),
                    );
                  }

                  // Cleanup
                  await CheckoutStorage().clearSnapshot();
                  await checkoutProvider.reset();
                  cartManager.clearCart();

                  if (mounted) {
                    Future.delayed(const Duration(seconds: 2), () {
                      // Back to home/shop
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    });
                  }
                }
              },
              child: const Text(
                "Place Order",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
    required CheckoutProvider checkoutProvider,
    required Color textColor,
  }) {
    final isSelected = checkoutProvider.selectedPaymentMethod == method;
    final isCard = method == PaymentMethod.card;

    return Column(
      children: [
        InkWell(
          onTap: () => checkoutProvider.setPaymentMethod(method),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF028A2B) : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF028A2B),
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Show tiny card placeholders for Stripe option
                if (isCard)
                  Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Visa/Master",
                        style: TextStyle(fontSize: 8, color: Colors.grey[400]),
                      ),
                    ],
                  )
                else
                  Icon(icon, color: Colors.grey[400], size: 24),
              ],
            ),
          ),
        ),
        // Conditional Redirect Info Panel
        if (isCard)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isSelected
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isDarkMode
                          ? Colors.grey[900]
                          : Colors.grey[50],
                      border: Border(
                        top: BorderSide(
                          color: widget.isDarkMode
                              ? Colors.black
                              : Colors.grey[200]!,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.credit_card_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "You’ll be redirected to Stripe to safely\ncomplete your purchase using your bank card.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity, height: 0),
          ),
      ],
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStep("Review", true, true),
        _buildLine(true),
        _buildStep("Address", true, true),
        _buildLine(true),
        _buildStep("Confirm", true, false),
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
