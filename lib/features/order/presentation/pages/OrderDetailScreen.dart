// lib/features/product/presentation/pages/order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/features/order/data/models/order_model.dart';
import 'package:mini_grocery/features/order/domain/entities/order_entity.dart';
import 'package:mini_grocery/features/order/presentation/providers/order_provider.dart';
import 'package:mini_grocery/features/product/presentation/providers/cart_provider.dart';
import 'package:mini_grocery/features/order/presentation/pages/order_screen.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your cart is empty!")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Map cart items to OrderProductModel
    final order = OrderModel(
  id: '',
  products: cartItems, // cartItems are ProductEntity already
  totalAmount: cartItems.fold(
      0, (sum, item) => sum + (item.price * item.quantity)),
  paymentMethod: 'cash',
  status: 'pending',
  shippingAddress: ShippingAddress(
  fullName: _fullNameController.text,
  phone: _contactController.text,
  street: _addressController.text,
  city: _cityController.text,           // <-- use controller
  postalCode: _postalCodeController.text, // <-- use controller
),
  createdAt: DateTime.now(),
);

      // Submit via provider
      await ref.read(submitOrderProvider.notifier).submitOrder(order);

// refresh orders so OrderScreen reloads
ref.invalidate(orderHistoryProvider);

// Clear cart
ref.read(cartProvider.notifier).clearCart();

      // Navigate to order history screen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrderScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit order: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.green, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter your name" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: "Address",
                          prefixIcon: Icon(Icons.home),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter your address" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: "City",
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter your city" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _postalCodeController,
                        decoration: const InputDecoration(
                          labelText: "Postal Code",
                          prefixIcon: Icon(Icons.markunread_mailbox),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter postal code" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _contactController,
                        decoration: const InputDecoration(
                          labelText: "Contact Number",
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            value!.isEmpty ? "Enter your contact number" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _remarksController,
                        decoration: const InputDecoration(
                          labelText: "Remarks (Optional)",
                          prefixIcon: Icon(Icons.note),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Submit Order",
                                style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}