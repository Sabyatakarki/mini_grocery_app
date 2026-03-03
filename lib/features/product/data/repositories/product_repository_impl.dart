import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_remote_datasource.dart';
import '../datasources/local/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;
  final ProductLocalDatasource localDatasource;

  ProductRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    final products = await remoteDatasource.getAllProducts();

    print("REPOSITORY PRODUCTS COUNT: ${products.length}");

    return products; // ✅ DIRECTLY RETURN REMOTE DATA
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    final products =
        await remoteDatasource.getProductsByCategory(category);

    return products;
  }
}