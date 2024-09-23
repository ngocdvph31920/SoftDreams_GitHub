import 'package:get/get.dart';
import 'package:inter_test/model/product.dart';
import 'package:inter_test/service/hive_service.dart';
import 'package:inter_test/presentations/popup/loading_popup.dart';
import 'package:flutter/material.dart';
import 'package:inter_test/presentations/features/home/controller/home_controller.dart';

enum StatusDelete {
  initial,
  inProcess,
  deleteSuccess,
}

class CartController extends GetxController {
  RxDouble totalPrice = 0.0.obs;
  var statusDelete = StatusDelete.initial.obs;
  final homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    fetchTotalPriceProduct();

    final context = Get.context;

    if (context == null) return;

    statusDelete.listen((status) {
      if (status == StatusDelete.deleteSuccess) {
        LoadingPopup.hideLoadingDialog(context);
        homeController.fetchProducts();
        fetchTotalPriceProduct();
      } else if (status == StatusDelete.inProcess) {
        LoadingPopup.showLoadingDialog(context);
      } else if (status == StatusDelete.initial) {
        LoadingPopup.hideLoadingDialog(context);
      }
    });
  }

  Future<void> removeProductInCart(Product product) async {
    statusDelete.value = StatusDelete.inProcess;
    await HiveService.deleteProduct(product);
    statusDelete.value = StatusDelete.deleteSuccess;
  }

  Future<void> fetchTotalPriceProduct() async {
    print("ngocdv tong tien $totalPrice");
    statusDelete.value = StatusDelete.initial;
    final listProductCart = await HiveService.getProducts();

    totalPrice.value =
        listProductCart.fold(0.0, (sum, product) => sum + product.price);
    totalPrice.value = double.parse(totalPrice.toStringAsFixed(2));
  }
}
