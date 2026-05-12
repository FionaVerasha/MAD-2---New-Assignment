import 'package:flutter/material.dart';
import 'home_page.dart';
import 'shop_page.dart';
import 'about_us_page.dart';
import 'profile_page.dart';

class MainScreen extends StatefulWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const MainScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkMode
        ? const Color(0xFF121212)
        : Colors.white;
    final selectedColor = widget.isDarkMode
        ? Colors.greenAccent[400]
        : const Color(0xFF2E7D32);
    final unselectedColor = widget.isDarkMode
        ? Colors.grey[400]
        : Colors.grey[600];

    // All pages with dark mode + toggle passed
    final List<Widget> pagesList = [
      HomePage(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      ShopPage(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      AboutUsPage(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      ProfilePage(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: pagesList[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: widget.isDarkMode
            ? const Color(0xFF2C2C2C)
            : Colors.white,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
