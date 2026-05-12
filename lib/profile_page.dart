import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'cart_manager.dart';
import 'cart_page.dart' as pages;
import 'widgets/brand_logo.dart';
import 'network_status_page.dart';
import 'battery_status_page.dart';
import 'location_page.dart';
import 'accelerometer_page.dart';
import 'order_history_page.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    final backgroundColor = widget.isDarkMode
        ? const Color(0xFF121212) // Black background
        : const Color(0xFFF1F8E9); // Light green theme

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: const BrandLogo(height: 55),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Standard search action
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => pages.CartPage(
                        isDarkMode: widget.isDarkMode,
                        onToggleTheme: widget.onToggleTheme,
                      ),
                    ),
                  );
                },
              ),
              Consumer<CartManager>(
                builder: (context, cart, child) {
                  return cart.totalItems > 0
                      ? Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              cart.totalItems.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ],
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.onToggleTheme(!widget.isDarkMode),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Ensures smooth scrolling
        child: Column(
          children: [
            _buildHeader(user),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Management Group
                  _buildMenuCard([
                    _buildMenuItem(
                      Icons.shopping_bag_outlined,
                      "Order History",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderHistoryPage(isDarkMode: widget.isDarkMode),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 16),
                  // Settings Group
                  _buildMenuCard([
                    _buildMenuItem(
                      Icons.wb_sunny_outlined,
                      "Theme",
                      trailing: widget.isDarkMode ? "Dark mode" : "Light mode",
                      onTap: () => widget.onToggleTheme(!widget.isDarkMode),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  // Monitor/Capability Group (Requested order)
                  _buildMenuCard([
                    _buildMenuItem(
                      Icons.wifi,
                      "Network Status",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NetworkStatusPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      Icons.battery_full,
                      "Battery Status",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BatteryStatusPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      Icons.location_on_outlined,
                      "Location (GPS)",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocationPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      Icons.sensors,
                      "Accelerometer",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccelerometerPage(),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildLogoutButton(auth),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      child: Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black12, width: 2),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: widget.isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[200],
                child: Icon(
                  Icons.person,
                  size: 70,
                  color: widget.isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isDarkMode ? Colors.grey[850] : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 24,
                  color: Color(
                    0xFF477856,
                  ), // Using your brand green for the icon
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    String? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: widget.isDarkMode ? Colors.white : Colors.black87,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: widget.isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          const Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(AuthProvider auth) {
    return ListTile(
      onTap: () => auth.logout(),
      leading: const Icon(Icons.logout, color: Colors.redAccent),
      title: const Text(
        "Logout",
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
