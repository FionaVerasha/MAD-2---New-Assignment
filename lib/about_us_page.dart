import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'cart_page.dart' as pages;
import 'widgets/brand_logo.dart';

class AboutUsPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const AboutUsPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    // Access cart provider
    Provider.of<CartManager>(context, listen: false);

    final backgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF1F8E9);
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode
        ? Colors.grey[400]!
        : const Color(0xFF374151);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: const BrandLogo(height: 55),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: _AboutSearchDelegate());
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
                        onToggleTheme: onToggleTheme,
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
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => onToggleTheme(!isDarkMode),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Body with Dark/Light theme support
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                      : [const Color(0xFFC8E6C9), const Color(0xFFF1F8E9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: _buildTextSection(context, textColor, subTextColor),
            ),
          ],
        ),
      ),
    );
  }

  // Hero Section
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=1200&q=80',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF1B9E4B)),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.pets, size: 50, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  // Text Section
  Widget _buildTextSection(
    BuildContext context,
    Color textColor,
    Color subTextColor,
  ) {
    const greenColor = Color(0xFF1B9E4B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: greenColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "ABOUT WHISKER CART",
            style: TextStyle(
              color: greenColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Title 1
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: textColor,
              height: 1.2,
              fontFamily: 'Inter',
            ),
            children: [
              const TextSpan(text: "Providing Everything Your\n"),
              TextSpan(
                text: "Pet Deserves",
                style: TextStyle(color: greenColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Description 1
        Text(
          "At Whisker Cart, we believe that pets aren't just animals—they're family. "
          "Our mission is to simplify pet care by offering a curated selection of "
          "premium products, backed by expert support and lightning-fast delivery.",
          style: TextStyle(
            color: subTextColor,
            fontSize: 17,
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 48),

        // Title 2: Who We Are
        Text(
          "Who We Are",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),

        // Description 2
        Text(
          "Founded in 2024 by a team of dedicated pet parents and veterinarians, "
          "Whisker Cart was born out of a desire to create a shopping experience "
          "that prioritizes health, safety, and joy. We hand-pick every item in our "
          "store to ensure it meets our rigorous standards for quality and pet happiness.",
          style: TextStyle(color: subTextColor, fontSize: 17, height: 1.6),
        ),
        const SizedBox(height: 24),

        // Checklist
        _buildCheckItem(
          "Carefully curated pet products",
          subTextColor,
          greenColor,
        ),
        _buildCheckItem("Fast and reliable delivery", subTextColor, greenColor),
        _buildCheckItem("Pet-first customer support", subTextColor, greenColor),

        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: greenColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 2,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/contact_us');
          },
          child: const Text(
            "Contact Us",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(String text, Color textColor, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple SearchDelegate (same behavior as in HomePage)
class _AboutSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) =>
      Center(child: Text('Search results for "$query"'));

  @override
  Widget buildSuggestions(BuildContext context) =>
      const Center(child: Text("Search for products..."));
}
