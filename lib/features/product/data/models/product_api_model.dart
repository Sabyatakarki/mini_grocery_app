import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.quantity,
    required super.category,
    required super.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"],
      name: json["name"],
      price: (json["price"] as num).toDouble(),
      quantity: json["quantity"],
      category: json["category"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "price": price,
      "quantity": quantity,
      "category": category,
      "image": image,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      category: category,
      image: image,
    );
  }
}