import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:inter_test/model/product.dart';
import 'package:inter_test/service/hive_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StatusDelete {
  initial,
  inProcess,
  deleteSuccess,
}

class CartController extends GetxController {
  RxDouble totalPrice = 0.0.obs;
  var statusDelete = StatusDelete.initial.obs;

  Future<void> removeProductInCart(Product product) async {
    statusDelete.value = StatusDelete.inProcess;
    await HiveService.deleteProduct(product);
    statusDelete.value = StatusDelete.deleteSuccess;
  }

  Future<void> fetchTotalPriceProduct() async {
    statusDelete.value = StatusDelete.initial;
    final listProductCart = await HiveService.getProducts();

    totalPrice.value =
        listProductCart.fold(0.0, (sum, product) => sum + product.price);
    totalPrice.value = double.parse(totalPrice.toStringAsFixed(2));
  }
}
