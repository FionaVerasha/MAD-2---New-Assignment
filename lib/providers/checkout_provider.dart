import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/shipping_address.dart';
import '../models/payment_method.dart';

class CheckoutProvider extends ChangeNotifier {
  ShippingAddress _address = ShippingAddress();
  bool _isAddressComplete = false;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cod;

  ShippingAddress get address => _address;
  bool get isAddressComplete => _isAddressComplete;
  PaymentMethod get selectedPaymentMethod => _selectedPaymentMethod;

  void setPaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  CheckoutProvider() {
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? addressJson = prefs.getString('shipping_address');
    if (addressJson != null) {
      _address = ShippingAddress.fromJson(json.decode(addressJson));
      _isAddressComplete = true;
      notifyListeners();
    }
  }

  Future<void> saveAddress(ShippingAddress newAddress) async {
    _address = newAddress;
    _isAddressComplete = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shipping_address', json.encode(_address.toJson()));
    notifyListeners();
  }

  Future<void> reset() async {
    _address = ShippingAddress();
    _isAddressComplete = false;
    _selectedPaymentMethod = PaymentMethod.cod;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('shipping_address');
    notifyListeners();
  }
}
