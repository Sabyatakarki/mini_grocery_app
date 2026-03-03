import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// --- Get All Products Use Case ---
class GetAllProductsUseCase {
  final ProductRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<List<ProductEntity>> call() async {
    return await repository.getAllProducts();
  }
}

/// --- Get Products By Category Use Case ---
class GetProductsByCategoryUseCase {
  final ProductRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<List<ProductEntity>> call(String category) async {
    return await repository.getProductsByCategory(category);
  }
}

