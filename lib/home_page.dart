import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shop_page.dart';
import 'cart_page.dart' as pages;
import 'cart_manager.dart';
import 'providers/product_provider.dart';
import 'models/product.dart';
import 'productdetail_page.dart';
import 'widgets/product_image.dart';
import 'widgets/brand_logo.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartManager>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFE8F0E6),
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
                        isDarkMode: isDarkMode,
                        onToggleTheme: widget.onToggleTheme,
                      ),
                    ),
                  );
                },
              ),
              if (cart.totalItems > 0)
                Positioned(
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
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() => isDarkMode = !isDarkMode);
              widget.onToggleTheme(isDarkMode);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section (Diagonal Split)
            _buildHero(),

            // Category Quick Selection
            _buildCategoryQuickSection(),

            // Proper Pet Care / Accessories Banners
            _buildDoubleBanners(),

            // Trust Icons
            _buildTrustSection(),

            // Get 20% Off Products
            _buildProductGridSection(
              "GET 20% OFF",
              productProvider.products.take(4).toList(),
              productProvider.isLoading,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          // Full Background Image (Puppy and Kitten)
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1450778869180-41d0601e046e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay for text readability
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          // Text Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "All Products",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Save 50% Off",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  "Happy Pet, Happy You",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShopPage(
                          isDarkMode: isDarkMode,
                          onToggleTheme: widget.onToggleTheme,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "SHOP NOW",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryQuickSection() {
    final categories = [
      {
        "title": "Dog Supplies",
        "image":
            "https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?auto=format&fit=crop&w=300&q=80",
        "color": Color(0xFFB3D9EA),
      },
      {
        "title": "Cat Supplies",
        "image":
            "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=300&q=80",
        "color": Color(0xFFF7B9BA),
      },
      {
        "title": "Other Utensils",
        "image":
            "https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=300&q=80",
        "color": Color(0xFFF9D199),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Row(
        children: categories
            .map(
              (cat) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        color: cat['color'] as Color,
                        child: Image.network(
                          cat['image'] as String,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              cat['title'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              maxLines: 1,
                            ),
                            const Text(
                              "Flea & Tick, Health etc.",
                              style: TextStyle(fontSize: 9, color: Colors.grey),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShopPage(
                                      isDarkMode: isDarkMode,
                                      onToggleTheme: widget.onToggleTheme,
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                minimumSize: const Size(0, 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                "SHOP NOW",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDoubleBanners() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _buildWideBanner(
            "PROPER PET CARE",
            "https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?auto=format&fit=crop&w=300&q=80",
          ),
          const SizedBox(width: 15),
          _buildWideBanner(
            "PET ACCESSORIES",
            "https://images.unsplash.com/photo-1544568100-847a948585b9?auto=format&fit=crop&w=300&q=80",
          ),
        ],
      ),
    );
  }

  Widget _buildWideBanner(String title, String imageUrl) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const Text(
            "We have all the best products for your pet!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustSection() {
    final features = [
      {"icon": Icons.headset_mic_outlined, "title": "24/7 FRIENDLY SUPPORT"},
      {"icon": Icons.local_shipping_outlined, "title": "FREE SHIPPING"},
      {"icon": Icons.assignment_return_outlined, "title": "7 DAYS EASY RETURN"},
      {"icon": Icons.verified_user_outlined, "title": "QUALITY GUARANTEED"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
      child: Row(
        children: features
            .map(
              (f) => Expanded(
                child: Column(
                  children: [
                    Icon(
                      f['icon'] as IconData,
                      size: 28,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      f['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      "Our support team is always ready.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 6,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildProductGridSection(
    String title,
    List<Product> products,
    bool isLoading,
  ) {
    return Column(
      children: [
        const Text(
          "GET 20% OFF",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: products
                .take(4)
                .map(
                  (p) => Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(
                              product: p,
                              isDarkMode: isDarkMode,
                              onToggleTheme: widget.onToggleTheme,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.grey[100],
                              height: 100,
                              child: ProductImage(url: p.imageUrl),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class HeroDiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bluePaint = Paint()..color = const Color(0xFF5BA7C8);
    final orangePaint = Paint()..color = const Color(0xFFF9B87A);

    // Draw blue background half
    final bluePath = Path();
    bluePath.moveTo(0, 0);
    bluePath.lineTo(size.width * 0.6, 0);
    bluePath.lineTo(size.width * 0.4, size.height);
    bluePath.lineTo(0, size.height);
    bluePath.close();
    canvas.drawPath(bluePath, bluePaint);

    // Draw orange background half
    final orangePath = Path();
    orangePath.moveTo(size.width * 0.6, 0);
    orangePath.lineTo(size.width, 0);
    orangePath.lineTo(size.width, size.height);
    orangePath.lineTo(size.width * 0.4, size.height);
    orangePath.close();
    canvas.drawPath(orangePath, orangePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
