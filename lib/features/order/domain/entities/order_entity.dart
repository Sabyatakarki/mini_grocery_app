// lib/features/product/domain/entities/order_entity.dart
import 'package:mini_grocery/features/product/domain/entities/product_entity.dart';

class Order {
  final String id;
  final List<ProductEntity> products;
  final double totalAmount;
  final String paymentMethod;
  final String status; // pending, confirmed, delivered
  final ShippingAddress shippingAddress;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.products,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
  });
}

class ShippingAddress {
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String? postalCode;

  ShippingAddress({
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    this.postalCode,
  });
}