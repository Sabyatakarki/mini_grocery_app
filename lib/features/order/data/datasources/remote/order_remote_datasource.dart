// lib/features/product/data/datasources/order_remote_datasource.dart
import 'package:mini_grocery/core/api/api_client.dart';
import 'package:mini_grocery/features/order/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(Map<String, dynamic> orderData);
  Future<List<OrderModel>> getMyOrders();
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await apiClient.post('/api/orders', data: orderData);
      return OrderModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await apiClient.get('/api/orders/my');
      final List data = response.data['data'];
      return data.map((order) => OrderModel.fromJson(order)).toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}