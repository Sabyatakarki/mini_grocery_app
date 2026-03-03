import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mini_grocery/core/api/api_endpoints.dart';
import 'package:mini_grocery/features/product/data/models/product_api_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getAllProducts();
  Future<List<ProductModel>> getProductsByCategory(String category);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final Dio dio;

  ProductRemoteDatasourceImpl({required this.dio});

  /// Fetch all products
  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await dio.get(ApiEndpoints.products);

      if (kDebugMode) {
        debugPrint("GET /products response: ${response.data}");
      }

      final data = response.data['data'];

      if (data is List) {
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else if (data is Map<String, dynamic>) {
        // Backend sometimes returns a single object
        return [ProductModel.fromJson(data)];
      } else {
        return [];
      }
    } catch (e, st) {
      debugPrint('Error fetching all products: $e\n$st');
      rethrow;
    }
  }

  /// Fetch products by category
  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await dio.get(
        ApiEndpoints.products,
        queryParameters: {"category": category},
      );

      if (kDebugMode) {
        debugPrint("GET /products?category=$category response: ${response.data}");
      }

      final data = response.data['data'];

      if (data is List) {
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else if (data is Map<String, dynamic>) {
        return [ProductModel.fromJson(data)];
      } else {
        return [];
      }
    } catch (e, st) {
      debugPrint('Error fetching products by category: $e\n$st');
      rethrow;
    }
  }
}