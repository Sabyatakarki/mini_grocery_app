// lib/features/order/presentation/providers/order_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/api/api_client.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:mini_grocery/features/order/data/datasources/local/order_local_datasource.dart';
import 'package:mini_grocery/features/order/data/datasources/remote/order_remote_datasource.dart';
import 'package:mini_grocery/features/order/data/repositories/order_repository_impl.dart';
import 'package:mini_grocery/features/order/domain/entities/order_entity.dart';
import 'package:mini_grocery/features/order/domain/repositories/order_repository.dart';

/// ----------------- Data Sources Providers -----------------
final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  return OrderRemoteDataSourceImpl(
    apiClient: ref.read(apiClientProvider),
  );
});

final orderLocalDataSourceProvider = Provider<OrderLocalDataSource>((ref) {
  return OrderLocalDataSourceImpl(
    sharedPreferences: ref.read(sharedPreferencesProvider),
  );
});

/// ----------------- Repository Provider -----------------
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(
    remoteDataSource: ref.read(orderRemoteDataSourceProvider),
    localDataSource: ref.read(orderLocalDataSourceProvider),
  );
});

/// ----------------- Order History Provider -----------------
final orderHistoryProvider = FutureProvider<List<Order>>((ref) async {
  final repo = ref.read(orderRepositoryProvider);
  return await repo.getOrders();
});

/// ----------------- Submit Order Notifier -----------------
final submitOrderProvider = StateNotifierProvider<SubmitOrderNotifier, bool>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return SubmitOrderNotifier(repo);
});

class SubmitOrderNotifier extends StateNotifier<bool> {
  final OrderRepository _repository;

  SubmitOrderNotifier(this._repository) : super(false);

  /// Submit order
  Future<void> submitOrder(Order order) async {
    state = true; // submitting
    try {
      // Pass the entity directly to repository
      await _repository.createOrder(order);
    } catch (e) {
      rethrow;
    } finally {
      state = false; // done
    }
  }
}