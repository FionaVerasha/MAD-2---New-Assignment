import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'dart:async';

class BatteryStatusPage extends StatefulWidget {
  const BatteryStatusPage({super.key});

  @override
  State<BatteryStatusPage> createState() => _BatteryStatusPageState();
}

class _BatteryStatusPageState extends State<BatteryStatusPage> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  bool _isLoading = true;
  StreamSubscription<BatteryState>? _batterySubscription;

  @override
  void initState() {
    super.initState();
    _initBattery();
    _batterySubscription = _battery.onBatteryStateChanged.listen((
      BatteryState state,
    ) {
      setState(() {
        _batteryState = state;
      });
      _getBatteryLevel();
    });
  }

  @override
  void dispose() {
    _batterySubscription?.cancel();
    super.dispose();
  }

  Future<void> _initBattery() async {
    await Future.wait([_getBatteryLevel(), _getBatteryState()]);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getBatteryLevel() async {
    try {
      final level = await _battery.batteryLevel;
      if (mounted) {
        setState(() {
          _batteryLevel = level;
        });
      }
    } catch (e) {
      debugPrint("Error fetching battery level: $e");
    }
  }

  Future<void> _getBatteryState() async {
    try {
      final state = await _battery.batteryState;
      if (mounted) {
        setState(() {
          _batteryState = state;
        });
      }
    } catch (e) {
      debugPrint("Error fetching battery state: $e");
    }
  }

  String _getBatteryStateText() {
    switch (_batteryState) {
      case BatteryState.charging:
        return "Charging";
      case BatteryState.discharging:
        return "Discharging";
      case BatteryState.full:
        return "Full";
      case BatteryState.unknown:
      default:
        return "Unknown";
    }
  }

  IconData _getBatteryIcon() {
    if (_batteryState == BatteryState.charging)
      return Icons.battery_charging_full;
    if (_batteryLevel <= 15) return Icons.battery_alert;
    if (_batteryLevel <= 30) return Icons.battery_3_bar;
    if (_batteryLevel <= 60) return Icons.battery_5_bar;
    return Icons.battery_full;
  }

  Color _getBatteryColor() {
    if (_batteryState == BatteryState.charging) return Colors.blue;
    if (_batteryLevel <= 20) return Colors.red;
    if (_batteryLevel <= 50) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Battery Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40.0,
                    horizontal: 20.0,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getBatteryIcon(),
                        size: 100,
                        color: _getBatteryColor(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "$_batteryLevel%",
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getBatteryStateText(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: _getBatteryColor(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() => _isLoading = true);
                          _initBattery();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("REFRESH"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 32),
            const Text(
              "* Web support may be limited or show 'Unknown'",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
