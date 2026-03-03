import 'package:hive/hive.dart';
import '../../domain/entities/product_entity.dart';

part 'product_hive_model.g.dart'; //dart run build_runner build -d

@HiveType(typeId: 0)
class ProductModel extends ProductEntity {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String name;

  @override
  @HiveField(2)
  final int quantity;

  @override
  @HiveField(3)
  final double price;

  @override
  @HiveField(4)
  final String category;

  @override
  @HiveField(5)
  final String image;

  ProductModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    required this.image,
  }) : super(
          id: id,
          name: name,
          quantity: quantity,
          price: price,
          category: category,
          image: image,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'category': category,
      'image': image,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      quantity: quantity,
      price: price,
      category: category,
      image: image,
    );
  }
}