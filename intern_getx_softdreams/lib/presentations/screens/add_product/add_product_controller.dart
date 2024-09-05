import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum StatusCreate {
  initial,
  inProcess,
  success,
  failure,
}

class AddProductController extends GetxController {
  final Dio dio = Dio();

  var statusCreate = StatusCreate.initial.obs;

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
}
