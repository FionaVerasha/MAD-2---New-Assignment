import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/checkout_provider.dart';
import 'models/shipping_address.dart';
import 'checkout_page.dart';

class ShippingAddressPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const ShippingAddressPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _address = ShippingAddress();

  @override
  void initState() {
    super.initState();
    final checkoutProvider = Provider.of<CheckoutProvider>(
      context,
      listen: false,
    );
    _address.firstName = checkoutProvider.address.firstName;
    _address.lastName = checkoutProvider.address.lastName;
    _address.address = checkoutProvider.address.address;
    _address.city = checkoutProvider.address.city;
    _address.state = checkoutProvider.address.state;
    _address.postalCode = checkoutProvider.address.postalCode;
    _address.phoneNumber = checkoutProvider.address.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    final appBarColor = widget.isDarkMode
        ? const Color(0xFF2C2C2C)
        : const Color(0xFF477856);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Shipping Address",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepper(),
              const SizedBox(height: 30),
              _buildTextField(
                label: "Shipping to",
                initialValue: _address.shippingTo,
                onSaved: (val) => _address.shippingTo = val!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "First Name",
                      initialValue: _address.firstName,
                      onSaved: (val) => _address.firstName = val!,
                      validator: (val) => val!.isEmpty ? "Required" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Last Name",
                      initialValue: _address.lastName,
                      onSaved: (val) => _address.lastName = val!,
                      validator: (val) => val!.isEmpty ? "Required" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Country",
                initialValue: _address.country,
                onSaved: (val) => _address.country = val!,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Address (Street Address)",
                initialValue: _address.address,
                onSaved: (val) => _address.address = val!,
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "City",
                initialValue: _address.city,
                onSaved: (val) => _address.city = val!,
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "State/Region",
                      initialValue: _address.state,
                      onSaved: (val) => _address.state = val!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Postal Code",
                      initialValue: _address.postalCode,
                      onSaved: (val) => _address.postalCode = val!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Phone Number",
                initialValue: _address.phoneNumber,
                keyboardType: TextInputType.phone,
                onSaved: (val) => _address.phoneNumber = val!,
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC8E6C9), // Light green
                    foregroundColor: const Color(0xFF028A2B), // Dark green text
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "SAVE",
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
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String?) onSaved,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        filled: true,
        fillColor: widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF028A2B), width: 1),
        ),
      ),
      style: TextStyle(
        color: widget.isDarkMode ? Colors.white : Colors.black87,
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStep("Review", true, true),
        _buildLine(true),
        _buildStep("Address", true, false),
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

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<CheckoutProvider>().saveAddress(_address);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Shipping address saved"),
          backgroundColor: Color(0xFF028A2B),
        ),
      );

      // Navigate to Confirm Order (CheckoutPage)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutPage(
            isDarkMode: widget.isDarkMode,
            onToggleTheme: widget.onToggleTheme,
          ),
        ),
      );
    }
  }
}
