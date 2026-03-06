// lib/features/product/data/datasources/order_local_datasource.dart
import 'dart:convert';
import 'package:mini_grocery/features/order/data/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OrderLocalDataSource {
  Future<void> cacheOrders(List<OrderModel> orders);
  Future<List<OrderModel>> getCachedOrders();
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const cachedOrdersKey = 'CACHED_ORDERS';

  OrderLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheOrders(List<OrderModel> orders) async {
    final jsonString = jsonEncode(orders.map((o) => o.toJson()).toList());
    await sharedPreferences.setString(cachedOrdersKey, jsonString);
  }

  @override
  Future<List<OrderModel>> getCachedOrders() async {
    final jsonString = sharedPreferences.getString(cachedOrdersKey);
    if (jsonString != null) {
      final List data = jsonDecode(jsonString);
      return data.map((order) => OrderModel.fromJson(order)).toList();
    } else {
      return [];
    }
  }
}