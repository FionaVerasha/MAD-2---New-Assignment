import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerPage extends StatefulWidget {
  const AccelerometerPage({super.key});

  @override
  State<AccelerometerPage> createState() => _AccelerometerPageState();
}

class _AccelerometerPageState extends State<AccelerometerPage> {
  double? _x, _y, _z;
  StreamSubscription<AccelerometerEvent>? _subscription;
  bool _available = true;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  void _subscribe() {
    _subscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        if (mounted) {
          setState(() {
            _x = event.x;
            _y = event.y;
            _z = event.z;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _available = false;
          });
        }
      },
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accelerometer"),
        backgroundColor: const Color(0xFF556B2F),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFFF5F7F9),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_available)
                const Card(
                  color: Colors.redAccent,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Accelerometer sensor not available on this device.",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else ...[
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24.0,
                      horizontal: 16.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Live Data Feed",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildValueRow("X-Axis", _x),
                        const Divider(height: 32),
                        _buildValueRow("Y-Axis", _y),
                        const Divider(height: 32),
                        _buildValueRow("Z-Axis", _z),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Tilt your device or emulator to see values update.",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueRow(String axis, double? value) {
    return Column(
      children: [
        Text(
          axis,
          style: const TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value?.toStringAsFixed(2) ?? "0.00",
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
