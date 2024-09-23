import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inter_test/presentations/popup/loading_popup.dart';

enum StatusCreate {
  initial,
  inProcess,
  success,
  failure,
}

class AddProductController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController coverController = TextEditingController();

  final Dio dio = Dio();
  var statusCreate = StatusCreate.initial.obs;

  @override
  void onInit() {
    super.onInit();
    statusCreate.listen((status) {
      final BuildContext? context = Get.context;
      if (context == null) return;

      if (status == StatusCreate.success) {
        LoadingPopup.hideLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Add product success"),
          ),
        );
        Get.back();
      } else if (status == StatusCreate.failure) {
        LoadingPopup.hideLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Add failure"),
          ),
        );
      } else if (status == StatusCreate.inProcess) {
        LoadingPopup.showLoadingDialog(context);
      } else if (status == StatusCreate.initial) {
        LoadingPopup.hideLoadingDialog(context);
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
      statusCreate.value = StatusCreate.inProcess;
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
        statusCreate.value = StatusCreate.success;
      } else {
        statusCreate.value = StatusCreate.failure;
      }
    } catch (e) {
      statusCreate.value = StatusCreate.failure;
    }
  }

  void submitProduct() {
    try {
      final name = nameController.text;
      final quantity = int.parse(quantityController.text);
      final price = int.parse(priceController.text);
      final coverUrl = coverController.text;

      createProduct(
        name: name,
        quantity: quantity,
        price: price,
        coverUrl: coverUrl,
      );
    } catch (e) {
      // Handle the error
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
