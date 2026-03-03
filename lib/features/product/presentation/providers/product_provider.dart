import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:mini_grocery/core/api/api_endpoints.dart';
import 'package:mini_grocery/features/product/data/datasources/local/product_local_datasource.dart';
import 'package:mini_grocery/features/product/data/datasources/remote/product_remote_datasource.dart';
import 'package:mini_grocery/features/product/data/repositories/product_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_product_usecase.dart';


// --- Dio provider ---
final dioProvider = Provider<Dio>((ref) {
  return Dio(
  BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
  ),
); // replace with your base URL
});

// --- Datasource providers ---
final productRemoteDatasourceProvider = Provider<ProductRemoteDatasource>((ref) {
  final dio = ref.read(dioProvider);
  return ProductRemoteDatasourceImpl(dio: dio);
});

final productLocalDatasourceProvider = Provider<ProductLocalDatasource>((ref) {
  return ProductLocalDatasourceImpl(); // your Hive local cache implementation
});

// --- Repository provider ---
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remote = ref.read(productRemoteDatasourceProvider);
  final local = ref.read(productLocalDatasourceProvider);
  return ProductRepositoryImpl(remoteDatasource: remote, localDatasource: local);
});

// --- Use case providers ---
final getAllProductsUseCaseProvider = Provider<GetAllProductsUseCase>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return GetAllProductsUseCase(repo);
});

final getProductsByCategoryUseCaseProvider = Provider<GetProductsByCategoryUseCase>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return GetProductsByCategoryUseCase(repo);
});

// --- Product Notifier ---
final productProvider = StateNotifierProvider<ProductNotifier, AsyncValue<List<ProductEntity>>>(
  (ref) => ProductNotifier(ref),
);

class ProductNotifier extends StateNotifier<AsyncValue<List<ProductEntity>>> {
  final Ref ref;

  late final GetAllProductsUseCase _getAllProductsUseCase;
  late final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  ProductNotifier(this.ref) : super(const AsyncValue.loading()) {
    _getAllProductsUseCase = ref.read(getAllProductsUseCaseProvider);
    _getProductsByCategoryUseCase = ref.read(getProductsByCategoryUseCaseProvider);

    fetchProducts();
  }

  // Fetch all products
  Future<void> fetchProducts() async {
    state = const AsyncValue.loading();
    try {
      final products = await _getAllProductsUseCase();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Fetch products by category
  Future<void> fetchCategory(String category) async {
    state = const AsyncValue.loading();
    try {
      final products = await _getProductsByCategoryUseCase(category);
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}