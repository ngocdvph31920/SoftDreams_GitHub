import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../model/product.dart';
import '../repository/detail_repo.dart';

class DetailController extends GetxController {
  final DetailProductRepo detailProductRepo = Get.find();
  final isLoading = false.obs;
  var product = Rxn<Product>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController coverUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final validateMode = AutovalidateMode.disabled.obs;

  @override
  void onInit() {
    super.onInit();
    product.value = Get.arguments as Product;
    fetchProducts();
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    coverUrlController.dispose();
  }

  Future<void> fetchProducts() async {
    nameController.text = product.value?.name ?? '';
    priceController.text = product.value?.price.toString() ?? '';
    quantityController.text = product.value?.quantity.toString() ?? '';
    coverUrlController.text = product.value?.cover ?? '';
  }

  Future<bool> deleteProduct(int productId) async {
    try {
      final response = await detailProductRepo.deleteProduct(productId);

      if (response.success) {
        Get.snackbar("Xóa Thành công", response.message);
        return true;
      } else {
        Get.snackbar("Lỗi", response.message);
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  Future<void> updateProduct() async {
    final id = product.value?.id;
    if (id == null) {
      return;
    }
    validateMode.value = AutovalidateMode.always;
    try {
      final updatedProduct = Product(
        id: id,
        name: nameController.text,
        price: int.tryParse(priceController.text) ?? 0,
        quantity: int.tryParse(quantityController.text) ?? 0,
        cover: coverUrlController.text,
      );
      final response = await detailProductRepo.updateProducts(updatedProduct);
      print('NgocDV  update response $response');
      if (response.success) {
        Get.back(result: 'updated');
        Get.snackbar("Thành công", "Sản phẩm đã được cập nhật");
      } else {
        Get.snackbar("Lỗi", response.message);
      }
    } catch (e) {
      print('NgocDV  update failure e = $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createProduct() async {
    validateMode.value = AutovalidateMode.always;
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      final newProduct = Product(
        id: 0,
        name: nameController.text,
        price: int.tryParse(priceController.text) ?? 0,
        quantity: int.tryParse(quantityController.text) ?? 0,
        cover: coverUrlController.text,
      );
      await Future.delayed(const Duration(microseconds: 100));
      try {
        final response = await detailProductRepo.createProduct(newProduct);
        if (response.success) {
          Get.back(result: 'create');
          Get.snackbar("Thành công", "Sản phẩm đã được tạo mới");
        } else {
          Get.snackbar("Lỗi", response.message);
        }
      } catch (e) {
      } finally {
        isLoading.value = false;
      }
    }
  }
}
