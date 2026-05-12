import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_manager.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/checkout_provider.dart';
import 'login_page.dart';
import 'main_screen.dart';
import 'about_us_page.dart';
import 'landing_page.dart';
import 'controllers/product_controller.dart';
import 'controllers/order_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartManager()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        Provider(create: (_) => ProductController()),
        Provider(create: (_) => OrderController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whisker Cart ANDROID',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),

      // Handles login and routing logic
      home: _AuthGate(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),

      // Named routes
      routes: {
        '/login': (_) => const LoginPage(),
        '/main': (_) =>
            MainScreen(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
        '/about': (_) =>
            AboutUsPage(isDarkMode: _isDarkMode, onToggleTheme: _toggleTheme),
      },
    );
  }

  // Light Theme
  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(
        0xFFF1F8E9,
      ), // Light green background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF477856), // New Forest Green
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6B8E23),
        primary: const Color(0xFF6B8E23),
      ),
    );
  }

  // Dark Theme
  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1B5E20), // Very dark green
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF477856),
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.dark,
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const _AuthGate({required this.onToggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.status == AuthStatus.loading ||
        auth.status == AuthStatus.unknown) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
        ),
      );
    }

    if (auth.status == AuthStatus.authenticated) {
      return MainScreen(onToggleTheme: onToggleTheme, isDarkMode: isDarkMode);
    }
    return const LandingPage();
  }
}
