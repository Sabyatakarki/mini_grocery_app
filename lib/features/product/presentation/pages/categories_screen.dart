// lib/features/product/presentation/pages/categories_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:mini_grocery/core/constants/contants.dart';
import 'package:mini_grocery/core/utils/snackbar_utils.dart';
import 'package:mini_grocery/features/product/domain/entities/product_entity.dart';
import 'package:mini_grocery/features/product/presentation/providers/cart_provider.dart';
import 'package:mini_grocery/features/product/presentation/providers/product_provider.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          "Explore Categories",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: productsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.green)),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (products) {
          // Filter by search query
          final filteredProducts = products.where((p) {
            final name = p.name.toLowerCase() ?? "";
            return name.contains(searchQuery.toLowerCase());
          }).toList();

          // Group by category
          final Map<String, List<ProductEntity>> groupedProducts = {};
          for (var product in filteredProducts) {
            final category = product.category ?? "Others";
            groupedProducts.putIfAbsent(category, () => []).add(product);
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildSearchBar(),
              const SizedBox(height: 30),
              ...groupedProducts.entries
                  .map((entry) => _buildCategorySection(entry.key, entry.value)),
            ],
          );
        },
      ),
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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

  Widget _buildCategorySection(String title, List<ProductEntity> categoryProducts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("See All",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categoryProducts.length,
            itemBuilder: (context, index) {
              final product = categoryProducts[index];
              return _buildProductCard(product);
            },
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildProductCard(ProductEntity product) {
    final imageUrl = "${AppConstants.baseImageUrl}${product.image}";

    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 18, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image_outlined),
                  ),
                ),
                // Add to Cart Button
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(cartProvider.notifier).addToCart(product);
                      // Use SnackbarUtils instead of local _showSnackBar
                      SnackbarUtils.showSuccess(context, "${product.name} added to cart!");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.greenAccent, blurRadius: 4)],
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name ?? "Fresh Item",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Row(
                    children: [
                      const Text(
                        "Rs ",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      Text(
                        "${product.price ?? 0}",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}