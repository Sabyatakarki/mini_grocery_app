// lib/features/order/domain/repositories/order_repository.dart
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<Order> createOrder(Order order); // Accept Order entity
  Future<List<Order>> getOrders({bool forceRefresh = false});
}