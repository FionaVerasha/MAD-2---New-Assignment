import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/checkout_snapshot.dart';

class CheckoutStorage {
  static const String _key = 'checkout_snapshot';

  Future<void> saveSnapshot(CheckoutSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(snapshot.toJson()));
  }

  Future<CheckoutSnapshot?> loadSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return null;
    return CheckoutSnapshot.fromJson(json.decode(data));
  }

  Future<void> clearSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
