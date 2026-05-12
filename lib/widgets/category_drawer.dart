import 'package:flutter/material.dart';

class CategoryItem {
  final String label;
  final String slug;
  final IconData icon;

  CategoryItem({required this.label, required this.slug, required this.icon});
}

class CategoryDrawer extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final bool isDarkMode;

  CategoryDrawer({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.isDarkMode,
  });

  final List<CategoryItem> categories = [
    CategoryItem(
      label: "All Products",
      slug: "all",
      icon: Icons.grid_view_rounded,
    ),
    CategoryItem(
      label: "Premium Products",
      slug: "premium",
      icon: Icons.star_rounded,
    ),
    CategoryItem(
      label: "Cat Products",
      slug: "cat-food",
      icon: Icons.pets_rounded,
    ),
    CategoryItem(
      label: "Dog Products",
      slug: "dog-food",
      icon: Icons.pets_rounded,
    ),
    CategoryItem(
      label: "Pet Accessories",
      slug: "pet-essentials",
      icon: Icons.toys_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final accentColor = const Color(0xFF477856); // Brand Green

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7 > 320
          ? 320
          : MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 60, left: 20, bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(color: accentColor.withOpacity(0.1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.category_rounded,
                    size: 40,
                    color: Color(0xFF477856),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category.slug;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      onTap: () {
                        onCategorySelected(category.slug);
                        Navigator.pop(context); // Close drawer
                      },
                      leading: Icon(
                        category.icon,
                        color: isSelected ? Colors.white : accentColor,
                      ),
                      title: Text(
                        category.label,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? Colors.white : textColor,
                        ),
                      ),
                      tileColor: isSelected ? accentColor : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Whisker v1.0.0",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
