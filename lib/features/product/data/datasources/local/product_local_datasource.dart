import 'package:hive/hive.dart';
import 'package:mini_grocery/features/product/data/models/product_api_model.dart';

abstract class ProductLocalDatasource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<void> clearCache();
}

class ProductLocalDatasourceImpl implements ProductLocalDatasource {
  static const String _boxName = 'productsBox';

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final box = await Hive.openBox<ProductModel>(_boxName);
    await box.clear(); // optional: clear old cache
    for (var product in products) {
      await box.put(product.id, product); // use id as key
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final box = await Hive.openBox<ProductModel>(_boxName);
    return box.values.toList();
  }

  @override
  Future<void> clearCache() async {
    final box = await Hive.openBox<ProductModel>(_boxName);
    await box.clear();
  }
}