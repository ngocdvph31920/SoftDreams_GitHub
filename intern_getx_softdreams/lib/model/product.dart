import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String cover;

  @HiveField(2)
  String name;

  @HiveField(3)
  int price;

  @HiveField(4)
  int quantity;

  Product({
    required this.id,
    required this.cover,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      cover: json['cover'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "quantity": quantity,
    "cover": cover,
  };
}


