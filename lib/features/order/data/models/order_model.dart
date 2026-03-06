// lib/features/order/data/models/order_model.dart
import 'package:mini_grocery/features/order/domain/entities/order_entity.dart';
import 'package:mini_grocery/features/product/domain/entities/product_entity.dart';

class OrderModel extends Order {
  OrderModel({
    required super.id,
    required super.products,
    required super.totalAmount,
    required super.paymentMethod,
    required super.status,
    required super.shippingAddress,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final productsRaw = json['products'];

    final List<ProductEntity> parsedProducts = _parseProducts(productsRaw);

    final shippingRaw = (json['shippingAddress'] is Map<String, dynamic>)
        ? (json['shippingAddress'] as Map<String, dynamic>)
        : <String, dynamic>{};

    return OrderModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      products: parsedProducts,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: (json['paymentMethod'] ?? 'cash').toString(),
      status: (json['status'] ?? 'pending').toString(),
      shippingAddress: ShippingAddress(
        fullName: (shippingRaw['fullName'] ?? '').toString(),
        phone: (shippingRaw['phone'] ?? '').toString(),
        street: (shippingRaw['street'] ?? '').toString(),
        city: (shippingRaw['city'] ?? '').toString(),
        postalCode: (shippingRaw['postalCode'] ?? '').toString(),
      ),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
    );
  }

  /// Convert OrderModel to JSON (for backend)
  ///
  /// Sends products as:
  /// products: [ { product: "<id>", quantity: <qty> }, ... ]
  Map<String, dynamic> toJson() {
    return {
      // Many backends ignore _id on create; safe to include as id or blank.
      '_id': id,
      'products': products
          .map((p) => {
                'product': p.id,
                'quantity': p.quantity,
              })
          .toList(),
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'status': status,
      'shippingAddress': {
        'fullName': shippingAddress.fullName,
        'phone': shippingAddress.phone,
        'street': shippingAddress.street,
        'city': shippingAddress.city,
        'postalCode': shippingAddress.postalCode,
      },
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Convert from Entity to Model
  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      products: order.products,
      totalAmount: order.totalAmount,
      paymentMethod: order.paymentMethod,
      status: order.status,
      shippingAddress: order.shippingAddress,
      createdAt: order.createdAt,
    );
  }

  /// Convert from Model to Entity
  Order toEntity() {
    return Order(
      id: id,
      products: products,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      status: status,
      shippingAddress: shippingAddress,
      createdAt: createdAt,
    );
  }

  // -----------------------
  // Helpers
  // -----------------------

  static List<ProductEntity> _parseProducts(dynamic productsRaw) {
    if (productsRaw is! List) return <ProductEntity>[];

    return productsRaw.map<ProductEntity>((p) {
      // Case 3: products is a list of productId strings
      if (p is String) {
        return ProductEntity(
          id: p,
          name: '',
          price: 0,
          quantity: 1,
          category: 'Others',
          image: '',
        );
      }

      if (p is! Map) {
        // Unknown shape, return a safe empty product entity
        return ProductEntity(
          id: '',
          name: '',
          price: 0,
          quantity: 1,
          category: 'Others',
          image: '',
        );
      }

      final map = Map<String, dynamic>.from(p);

      final qtyRaw = map['quantity'];
      final int quantity = (qtyRaw is int)
          ? qtyRaw
          : int.tryParse(qtyRaw?.toString() ?? '') ?? 1;

      final prod = map['product'];

      // Case 2: product is just an id string
      if (prod is String) {
        return ProductEntity(
          id: prod,
          name: '',
          price: 0,
          quantity: quantity,
          category: 'Others',
          image: '',
        );
      }

      // Case 1: product is populated map
      if (prod is Map) {
        final product = Map<String, dynamic>.from(prod);

        final priceRaw = product['price'];
        final double price = (priceRaw is num)
            ? priceRaw.toDouble()
            : double.tryParse(priceRaw?.toString() ?? '') ?? 0.0;

        return ProductEntity(
          id: (product['_id'] ?? product['id'] ?? '').toString(),
          name: (product['name'] ?? '').toString(),
          price: price,
          quantity: quantity,
          category: (product['category'] ?? 'Others').toString(),
          image: (product['image'] ?? '').toString(),
        );
      }

      // Fallback: product key is missing or unexpected type
      return ProductEntity(
        id: '',
        name: '',
        price: 0,
        quantity: quantity,
        category: 'Others',
        image: '',
      );
    }).toList();
  }
}