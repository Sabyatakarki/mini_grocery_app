// lib/features/order/data/repositories/order_repository_impl.dart
import 'package:mini_grocery/features/order/data/datasources/local/order_local_datasource.dart';
import 'package:mini_grocery/features/order/data/datasources/remote/order_remote_datasource.dart';
import 'package:mini_grocery/features/order/data/models/order_model.dart';
import 'package:mini_grocery/features/order/domain/entities/order_entity.dart';
import 'package:mini_grocery/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Create order: accepts entity, converts to model internally
  @override
  Future<Order> createOrder(Order order) async {
    try {
      // Convert entity -> model
      final orderModel = OrderModel.fromEntity(order);

      // Send to remote API
      final createdModel = await remoteDataSource.createOrder(orderModel.toJson());

      // Cache locally as model
      final cachedOrders = await localDataSource.getCachedOrders();
      final cachedModels = cachedOrders.map((e) => OrderModel.fromEntity(e)).toList();
      await localDataSource.cacheOrders([createdModel, ...cachedModels]);

      // Return as entity
      return createdModel.toEntity();
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<List<Order>> getOrders({bool forceRefresh = false}) async {
    try {
      if (forceRefresh) {
        final remoteOrders = await remoteDataSource.getMyOrders();
        await localDataSource.cacheOrders(remoteOrders);
        return remoteOrders.map((e) => e.toEntity()).toList();
      }

      final cachedOrders = await localDataSource.getCachedOrders();
      if (cachedOrders.isNotEmpty) return cachedOrders;

      final remoteOrders = await remoteDataSource.getMyOrders();
      await localDataSource.cacheOrders(remoteOrders);
      return remoteOrders.map((e) => e.toEntity()).toList();
    } catch (e) {
      final cachedOrders = await localDataSource.getCachedOrders();
      if (cachedOrders.isNotEmpty) return cachedOrders;
      throw Exception('Failed to fetch orders: $e');
    }
  }
}