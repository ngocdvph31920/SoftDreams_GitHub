import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_test/model/product.dart';
import 'package:inter_test/presentations/features/add_product/repository/add_product_repo.dart';
import 'package:inter_test/presentations/popup/loading_popup.dart';

class AddProductController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController coverController = TextEditingController();

  final Dio dio = Dio();
  final AddProductRepo addProductRepo = Get.find();

  Future<void> createProduct() async {
    final BuildContext? context = Get.context;
    if (context == null) return;

    LoadingPopup.showLoadingDialog(context);

    final newProduct = Product(
      id: 0,
      name: nameController.text,
      price: int.tryParse(priceController.text) ?? 0,
      quantity: int.tryParse(quantityController.text) ?? 0,
      cover: coverController.text,
    );
    try {
      final response = await addProductRepo.createProduct(newProduct);
      if (response.success) {
        Get.back(result: 'create');
        Get.snackbar("Thành công", "Sản phẩm đã được tạo mới");
        LoadingPopup.hideLoadingDialog(context);
      } else {
        LoadingPopup.hideLoadingDialog(context);
        Get.snackbar("Lỗi", response.message);
      }
    } catch (e) {
      LoadingPopup.hideLoadingDialog(context);
      Get.snackbar("Lỗi", e.toString());
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    coverController.dispose();
    super.dispose();
  }
}
