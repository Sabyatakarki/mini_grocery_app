import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/api/api_endpoints.dart';
import 'package:mini_grocery/features/product/presentation/providers/product_provider.dart';
import 'package:mini_grocery/features/profile/presentation/pages/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String searchQuery = "";
  static final String baseImageUrl = "${ApiEndpoints.baseUrl}/uploads/products/";

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: _buildAppBar(context),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (products) {
          final filteredProducts = products
              .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              const Text(
                "Fresh Picks",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 25),
              _buildDiscountBanner(),
              const SizedBox(height: 30),
              _buildSectionHeader("Categories", () {}),
              const SizedBox(height: 15),
              _buildCategoryList(),
              const SizedBox(height: 30),
              _buildSectionHeader("Popular Deals", () {}),
              const SizedBox(height: 15),
              _buildProductGrid(filteredProducts),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          const Icon(Icons.location_on_rounded, color: Colors.green, size: 20),
          const SizedBox(width: 4),
          const Text(
            "Kathmandu, Nepal",
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[600], size: 18),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.black87),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (val) => setState(() => searchQuery = val),
      cursorColor: Colors.green,
      decoration: InputDecoration(
        hintText: "Search fruits, veggies...",
        prefixIcon: const Icon(Icons.search_rounded, color: Colors.green),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
                onPressed: () => setState(() => searchQuery = ""),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.green.shade400, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.green.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
        ),
      ),
    );
  }

  Widget _buildDiscountBanner() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Get 40% OFF",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("On your first grocery order",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Claim Now", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
            Image.asset("assets/images/veggies.png", height: 100, fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        TextButton(onPressed: onSeeAll, child: const Text("See All", style: TextStyle(color: Colors.green))),
      ],
    );
  }

  Widget _buildCategoryList() {
    final categories = [
      {'n': 'Veggies', 'i': Icons.eco, 'c': Colors.green},
      {'n': 'Fruits', 'i': Icons.apple, 'c': Colors.red},
      {'n': 'Meat', 'i': Icons.kebab_dining, 'c': Colors.orange},
      {'n': 'Dairy', 'i': Icons.emoji_food_beverage, 'c': Colors.blue},
    ];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, i) => _categoryItem(
          categories[i]['n'] as String,
          categories[i]['i'] as IconData,
          categories[i]['c'] as Color,
        ),
      ),
    );
  }

  Widget _categoryItem(String name, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(
                        "$baseImageUrl${product.image}",
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported)),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: const Icon(Icons.favorite_border, size: 18, color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rs ${product.price}",
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}