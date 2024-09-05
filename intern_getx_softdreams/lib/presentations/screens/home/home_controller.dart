import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:inter_test/model/product.dart';
import 'package:inter_test/service/hive_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StatusGetList {
  initial,
  inProcess,
  failure,
  success,
}

class HomeController extends GetxController {
  RxList<Product> listProductsCart = <Product>[].obs;
  RxList<Product> listProducts = <Product>[].obs;
  RxDouble totalPrice = 0.0.obs;
  var statusGetList = StatusGetList.initial.obs;

  final Dio dio = Dio();

  void totalPriceProduct() {
    totalPrice.value =
        listProductsCart.fold(0.0, (sum, product) => sum + product.price);
    totalPrice.value = double.parse(totalPrice.toStringAsFixed(2));
  }

  Future<void> addProductToCart(Product product) async {
    Product? existingProduct = listProductsCart.firstWhereOrNull(
      (p) => p.id == product.id,
    );

    if (existingProduct != null) return;

    final listProductCart = await HiveService.getProducts();
    listProductCart.add(product);

    await HiveService.saveProducts(listProductCart);

    fetchProducts();
  }

  Future<void> fetchProducts() async {
    statusGetList.value = StatusGetList.initial;

    final listProductCart = await HiveService.getProducts();

    listProductsCart.value = listProductCart;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("accessToken");

    var headers = {
      'Authorization': '$accessToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = await dio.get(
        'https://training-api-unrp.onrender.com/products',
        queryParameters: {
          'page': 1,
          'size': 100,
        },
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      Map<String, dynamic> jsonMap = json.decode(response.toString());

      bool success = jsonMap['success'];
      if (success) {
        List<Product> productList = (response.data['data'] as List)
            .map((productJson) => Product.fromJson(productJson))
            .toList();
        listProducts.value = productList;
        statusGetList.value = StatusGetList.success;
      } else {
        statusGetList.value = StatusGetList.failure;
      }
    } catch (e) {
      statusGetList.value = StatusGetList.failure;
    }
  }
}
