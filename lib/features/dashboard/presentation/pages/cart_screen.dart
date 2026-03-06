// lib/features/product/presentation/pages/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/features/order/presentation/pages/OrderDetailScreen.dart';
import 'package:mini_grocery/features/order/presentation/pages/order_screen.dart'; // ✅ ADD THIS
import 'package:mini_grocery/features/product/domain/entities/product_entity.dart';
import 'package:mini_grocery/features/product/presentation/providers/cart_provider.dart';
import 'package:mini_grocery/core/api/api_endpoints.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  static final String baseImageUrl = "${ApiEndpoints.baseUrl}/uploads/products/";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    double total = cartItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          "Your Cart",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,

        // ✅ ADD THIS ICON (right side)
        actions: [
          IconButton(
            tooltip: "My Orders",
            icon: const Icon(Icons.receipt_long, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderScreen()),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return _buildCartItem(context, ref, product);
              },
            ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(20),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: Rs $total",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const OrderDetailScreen()),
                          );
                        },
                        child: const Text(
                          "Place Order",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildCartItem(BuildContext context, WidgetRef ref, ProductEntity product) {
    final imageUrl = product.image.isNotEmpty
        ? "$baseImageUrl${product.image}"
        : "https://via.placeholder.com/150";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image_outlined),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  "Rs ${product.price * product.quantity}",
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text("Qty: "),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (product.quantity > 1) {
                          ref
                              .read(cartProvider.notifier)
                              .updateQuantity(product, product.quantity - 1);
                        }
                      },
                    ),
                    Text("${product.quantity}"),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        ref
                            .read(cartProvider.notifier)
                            .updateQuantity(product, product.quantity + 1);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ref.read(cartProvider.notifier).removeFromCart(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${product.name} removed from cart"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}