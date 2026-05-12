import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'services/checkout_storage.dart';
import 'providers/checkout_provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  bool _useAsBilling = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cartManager = Provider.of<CartManager>(context);

    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final appBarColor = isDarkMode
        ? const Color(0xFF2C2C2C)
        : const Color(0xFF2E7D32);
    final accentColor = isDarkMode
        ? Colors.greenAccent[700]!
        : const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepIndicator(),
              const SizedBox(height: 24),
              Text(
                "Payment Method",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildPaymentMethodCards(isDarkMode, textColor, accentColor),
              const SizedBox(height: 24),
              _buildTextField(
                label: "Card Number",
                hint: "0000 0000 0000 0000",
                icon: Icons.credit_card,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "Expiration (MM/YY)",
                      hint: "MM/YY",
                      isDarkMode: isDarkMode,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Security Code",
                      hint: "CVC",
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Voucher Code (Optional)",
                hint: "Enter code here",
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _useAsBilling,
                    activeColor: accentColor,
                    onChanged: (val) =>
                        setState(() => _useAsBilling = val ?? false),
                  ),
                  Expanded(
                    child: Text(
                      "I have designated my shipping address to also serve as my billing address.",
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
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
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Payment Successful! Order Confirmed."),
                        backgroundColor: Color(0xFF2E7D32),
                      ),
                    );

                    // Cleanup for local persistence
                    await CheckoutStorage().clearSnapshot();
                    if (mounted) {
                      await context.read<CheckoutProvider>().reset();
                      cartManager.clearCart();

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      });
                    }
                  }
                },
                child: const Text(
                  "Confirm and continue",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStepItem("Shipping", true),
        _buildStepItem("Payment", true),
        _buildStepItem("Review", false),
      ],
    );
  }

  Widget _buildStepItem(String label, bool isDone) {
    return Column(
      children: [
        Icon(
          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isDone ? const Color(0xFF2E7D32) : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDone ? const Color(0xFF2E7D32) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCards(
    bool isDarkMode,
    Color textColor,
    Color accentColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildTypeCard(
            "Credit Card",
            Icons.credit_card,
            true,
            accentColor,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTypeCard(
            "Virtual Account",
            Icons.account_balance_wallet,
            false,
            accentColor,
            isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCard(
    String title,
    IconData icon,
    bool isSelected,
    Color accentColor,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? accentColor.withOpacity(0.1)
            : (isDarkMode ? Colors.grey[900] : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? accentColor : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? accentColor : Colors.grey),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    IconData? icon,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon) : null,
            filled: true,
            fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: (val) => val == null || val.isEmpty ? "Required" : null,
        ),
      ],
    );
  }
}
