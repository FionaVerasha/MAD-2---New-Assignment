import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class NetworkStatusPage extends StatefulWidget {
  const NetworkStatusPage({super.key});

  @override
  State<NetworkStatusPage> createState() => _NetworkStatusPageState();
}

class _NetworkStatusPageState extends State<NetworkStatusPage> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  DateTime _lastUpdateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      debugPrint('Couldn\'t check connectivity status: $e');
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      _lastUpdateTime = DateTime.now();
    });
  }

  bool get _isOnline => !_connectionStatus.contains(ConnectivityResult.none);

  String get _connectionType {
    if (_connectionStatus.contains(ConnectivityResult.wifi)) return 'Wi-Fi';
    if (_connectionStatus.contains(ConnectivityResult.mobile)) return 'Mobile';
    if (_connectionStatus.contains(ConnectivityResult.ethernet) ||
        _connectionStatus.contains(ConnectivityResult.vpn) ||
        _connectionStatus.contains(ConnectivityResult.other))
      return 'Other';
    return 'None';
  }

  IconData get _statusIcon {
    if (_connectionStatus.contains(ConnectivityResult.wifi)) return Icons.wifi;
    if (_connectionStatus.contains(ConnectivityResult.mobile))
      return Icons.signal_cellular_4_bar;
    return Icons.wifi_off;
  }

  @override
  Widget build(BuildContext context) {
    final timeString =
        "${_lastUpdateTime.hour.toString().padLeft(2, '0')}:${_lastUpdateTime.minute.toString().padLeft(2, '0')}:${_lastUpdateTime.second.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Network Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                      _statusIcon,
                      size: 100,
                      color: _isOnline ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isOnline ? "Online" : "Offline",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _isOnline ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isOnline
                          ? "You are connected to the internet"
                          : "Check your connection and try again",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildStatusRow(
                      Icons.category_outlined,
                      "Connection Type",
                      _connectionType,
                      _isOnline ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    _buildStatusRow(
                      Icons.access_time,
                      "Last Updated",
                      timeString,
                      Colors.blueGrey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
