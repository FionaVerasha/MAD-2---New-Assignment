import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';



class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;
  Position? _currentPosition;
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();
      if (mounted) {
        setState(() {
          _serviceEnabled = serviceEnabled;
          _permission = permission;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error checking initial status: $e";
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _errorMessage = null;
      });
    }

    try {
      // 1. Check if services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _serviceEnabled = false;
            _loading = false;
            _errorMessage =
                "Location services are disabled. Please enable them in settings.";
          });
        }
        return;
      }

      // 2. Check/request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (mounted) {
        setState(() {
          _permission = permission;
        });
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _loading = false;
            _errorMessage =
                "Location permissions are permanently denied. Please open settings.";
          });
        }
        return;
      }

      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            _loading = false;
            _errorMessage = "Location permissions were denied.";
          });
        }
        return;
      }

      // 3. Fetch position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMessage = "Failed to get location: ${e.toString()}";
        });
      }
    }
  }

  Future<void> _requestPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (mounted) {
        setState(() {
          _permission = permission;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error requesting permission: $e";
        });
      }
    }
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return "N/A";
    try {
      return DateFormat('HH:mm:ss').format(timestamp);
    } catch (e) {
      return "Format Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location (GPS)"),
        backgroundColor: const Color(0xFF556B2F),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFFF5F7F9),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(color: Color(0xFF556B2F)),
                ),
              )
            else
              _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(
              "Location Services",
              _serviceEnabled ? "Enabled" : "Disabled",
              _serviceEnabled ? Colors.green : Colors.red,
            ),
            _buildInfoRow(
              "Permission",
              _permission.toString().split('.').last,
              _getPermissionColor(_permission),
            ),
            const Divider(height: 32),
            _buildInfoRow(
              "Latitude",
              _currentPosition?.latitude.toString() ?? "N/A",
            ),
            _buildInfoRow(
              "Longitude",
              _currentPosition?.longitude.toString() ?? "N/A",
            ),
            _buildInfoRow(
              "Accuracy (m)",
              _currentPosition?.accuracy.toStringAsFixed(1) ?? "N/A",
            ),
            _buildInfoRow(
              "Last Updated",
              _formatTimestamp(_currentPosition?.timestamp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPermissionColor(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return Colors.green;
      case LocationPermission.denied:
        return Colors.orange;
      case LocationPermission.deniedForever:
        return Colors.red;
      case LocationPermission.unableToDetermine:
        return Colors.grey;
    }
  }

  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _getCurrentLocation,
            icon: const Icon(Icons.my_location),
            label: const Text("Get Current Location"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF556B2F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (_permission == LocationPermission.denied) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: _requestPermission,
            child: const Text(
              "Request Permission",
              style: TextStyle(
                color: Color(0xFF556B2F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        if (_permission == LocationPermission.deniedForever) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => Geolocator.openAppSettings(),
            icon: const Icon(Icons.settings),
            label: const Text(
              "Open App Settings",
              style: TextStyle(
                color: Color(0xFF556B2F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
