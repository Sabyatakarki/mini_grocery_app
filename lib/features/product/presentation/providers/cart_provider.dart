import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';

class CartNotifier extends StateNotifier<List<ProductEntity>> {
  CartNotifier() : super([]);

  // Add product to cart
  void addToCart(ProductEntity product) {
    state = [...state, product];
  }

  // Remove product from cart
  void removeFromCart(ProductEntity product) {
    state = state.where((p) => p.id != product.id).toList();
  }

  // Clear entire cart
  void clearCart() {
    state = [];
  }

  // Update quantity of a product
  void updateQuantity(ProductEntity product, int newQty) {
    state = state.map((p) {
      if (p.id == product.id) {
        return ProductEntity(
          id: p.id,
          name: p.name,
          price: p.price,
          quantity: newQty,
          category: p.category,
          image: p.image,
        );
      }
      return p;
    }).toList();
  }
}

// Cart provider
final cartProvider = StateNotifierProvider<CartNotifier, List<ProductEntity>>(
  (ref) => CartNotifier(),
);