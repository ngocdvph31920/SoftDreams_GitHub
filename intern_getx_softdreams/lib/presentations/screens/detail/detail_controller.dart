import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:inter_test/model/product.dart';
import 'package:inter_test/service/hive_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DetailStatus {
  initial,
  inProcess,
  success,
  failure,
}

class DetailController extends GetxController {
  var status = DetailStatus.initial.obs;
  final Dio dio = Dio();

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

    HiveService.deleteProduct(product);
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
