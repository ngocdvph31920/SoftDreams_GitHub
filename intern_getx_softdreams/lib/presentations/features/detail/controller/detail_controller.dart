import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_test/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../service/hive_service_master.dart';
import '../../../popup/loading_popup.dart';

enum DetailStatus {
  initial,
  inProcess,
  success,
  failure,
}

class DetailController extends GetxController {
  var status = DetailStatus.initial.obs;
  final Dio dio = Dio();
  final HiveService hiveService = Get.find();

  late Product product;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController coverUrlController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Nhận đối tượng product từ arguments
    product = Get.arguments as Product;

    nameController.text = product.name;
    priceController.text = product.price.toString();
    quantityController.text = product.quantity.toString();
    coverUrlController.text = product.cover;

    ever(status, (DetailStatus status) {
      if (status == DetailStatus.success) {
        LoadingPopup.hideLoadingDialog(Get.context!);
        Get.back();
      } else if (status == DetailStatus.inProcess) {
        LoadingPopup.showLoadingDialog(Get.context!);
      } else if (status == DetailStatus.initial) {
        LoadingPopup.hideLoadingDialog(Get.context!);
        Get.back();
      } else if (status == DetailStatus.failure) {
        LoadingPopup.hideLoadingDialog(Get.context!);
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text("Error server"),
          ),
        );
        Get.back();
      }
    });
  }

  Future<void> createProduct({
    required String name,
    required int price,
    required int quantity,
    required String coverUrl,
  }) async {
    try {
      status.value = DetailStatus.inProcess;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("accessToken");

      final response = await dio.post(
        'https://training-api-unrp.onrender.com/products',
        data: {
          'name': name,
          'price': price,
          'quantity': quantity,
          'cover': coverUrl,
        },
        options: Options(
          headers: {
            'Authorization': '$accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      Map<String, dynamic> jsonMap = json.decode(response.toString());
      bool success = jsonMap['success'];

      if (success) {
        status.value = DetailStatus.success;
      } else {
        status.value = DetailStatus.failure;
      }
    } catch (e) {
      status.value = DetailStatus.failure;
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("accessToken");

      final response = await dio.delete(
        'https://training-api-unrp.onrender.com/products/$productId',
        options: Options(
          headers: {
            'Authorization': '$accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      Map<String, dynamic> jsonMap = json.decode(response.toString());
      bool success = jsonMap['success'];

      if (success) {
        status.value = DetailStatus.success;
      } else {
        status.value = DetailStatus.failure;
      }
    } catch (e) {
      status.value = DetailStatus.failure;
    }
  }

  Future<void> deleteProductFromList(Product product) async {
    status.value = DetailStatus.inProcess;

    hiveService.deleteProduct(product);
    await deleteProduct(product.id);
  }

  Future<void> updateProduct({
    required int productId,
    required String name,
    required int price,
    required int quantity,
    required String coverUrl,
  }) async {
    try {
      status.value = DetailStatus.inProcess;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("accessToken");

      final response = await dio.put(
        'https://training-api-unrp.onrender.com/products/$productId',
        data: {
          'name': name,
          'price': price,
          'quantity': quantity,
          'cover': coverUrl,
        },
        options: Options(
          headers: {
            'Authorization': '$accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      Map<String, dynamic> jsonMap = json.decode(response.toString());
      bool success = jsonMap['success'];

      if (success) {
        status.value = DetailStatus.success;
      } else {
        status.value = DetailStatus.failure;
      }
    } catch (e) {
      status.value = DetailStatus.failure;
    }
  }
}
