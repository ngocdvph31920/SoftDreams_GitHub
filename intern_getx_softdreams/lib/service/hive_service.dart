import 'package:hive/hive.dart';
import 'package:inter_test/model/product.dart';

class HiveService {
  static Future<void> saveProducts(List<Product> products) async {
    var box = await Hive.openBox<Product>('productsBox');
    await box.clear();
    await box.addAll(products);
  }

  static Future<List<Product>> getProducts() async {
    var box = await Hive.openBox<Product>('productsBox');
    return box.values.toList();
  }

  static Future<void> deleteProduct(Product product) async {
    List<Product> listProduct = await getProducts();
    if (listProduct.contains(product)) {
      listProduct.remove(product);
      saveProducts(listProduct);
    }
  }
}
