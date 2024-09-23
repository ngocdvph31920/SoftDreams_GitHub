import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:inter_test/model/product.dart';
import 'package:inter_test/service/hive_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:inter_test/presentations/popup/loading_popup.dart';
import 'package:inter_test/presentations/features/login/screen/login_screen.dart';

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

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    monitorStatus();
  }

  void monitorStatus() {
    statusGetList.listen((status) {
      final BuildContext? context = Get.context;
      if (context == null) return;

      if (status == StatusGetList.success) {
        LoadingPopup.hideLoadingDialog(context);
      } else if (status == StatusGetList.failure) {
        LoadingPopup.hideLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("GetList failure"),
          ),
        );
      } else if (status == StatusGetList.inProcess) {
        LoadingPopup.showLoadingDialog(context);
      } else if (status == StatusGetList.initial) {
        LoadingPopup.hideLoadingDialog(context);
      }
    });
  }

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

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    Get.offAll(() => const LoginScreen());
  }

  void showLogoutConfirmationDialog() {
    final BuildContext? context = Get.context;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Đăng xuất'),
              onPressed: () {
                Navigator.of(context).pop();
                logout();
              },
            ),
          ],
        );
      },
    );
  }
}
