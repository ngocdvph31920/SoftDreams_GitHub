import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../popup/loading_popup.dart';

enum StatusLogin {
  initial,
  inProcess,
  loginSuccess,
  loginFailure,
}

class LoginController extends GetxController {
  bool obscureText = true;
  final taxController = TextEditingController();
  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final taxFocusNode = FocusNode();
  final accountFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  var statusLogin = StatusLogin.initial.obs;
  final dio = Dio();

  Future<void> authentication() async {
    statusLogin.value = StatusLogin.inProcess;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("accessToken");

    if (accessToken != null) {
      statusLogin.value = StatusLogin.loginSuccess;
    } else {
      statusLogin.value = StatusLogin.initial;
    }
  }

  void login({
    required int taxCode,
    required String userName,
    required String passWord,
  }) async {
    statusLogin.value = StatusLogin.inProcess;
    try {
      final response = await dio.post(
        'https://training-api-unrp.onrender.com/login',
        data: jsonEncode({
          "tax_code": taxCode,
          "user_name": userName,
          "password": passWord,
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print('NgocDV okokokokok response = $response');

      Map<String, dynamic> jsonMap = json.decode(response.toString());

      bool success = jsonMap['success'];
      String message = jsonMap['message'];
      String token = jsonMap['token'];

      if (success) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", token);

        //save user vào hive

        statusLogin.value = StatusLogin.loginSuccess;
      } else {
        statusLogin.value = StatusLogin.loginFailure;
      }
    } catch (e) {
      statusLogin.value = StatusLogin.loginFailure;
    }
  }

  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      login(
        taxCode: int.parse(taxController.text),
        userName: accountController.text.trim(),
        passWord: passwordController.text.trim(),
      );
      ever(statusLogin, (status) {
        if (status == StatusLogin.loginSuccess) {
          Get.snackbar(
            'Đăng nhập thành công',
            'Bạn đã đăng nhập thành công.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else if (status == StatusLogin.loginFailure) {
          Get.snackbar(
            'Đăng nhập thất bại',
            'Tên đăng nhập hoặc mật khẩu không chính xác.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      });
    } else {
      Get.snackbar(
        'Lỗi xác thực',
        'Vui lòng kiểm tra lại thông tin.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    authentication();
    statusLogin.listen((status) {
      final buildContext = Get.context;

      if (buildContext == null) return;
      if (status == StatusLogin.loginSuccess) {
        LoadingPopup.hideLoadingDialog(buildContext);
        Get.toNamed('/home');
      } else if (status == StatusLogin.loginFailure) {
        LoadingPopup.hideLoadingDialog(buildContext);
      } else if (status == StatusLogin.inProcess) {
        LoadingPopup.showLoadingDialog(buildContext);
      } else if (status == StatusLogin.initial) {
        LoadingPopup.hideLoadingDialog(buildContext);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    taxController.dispose();
    accountController.dispose();
    passwordController.dispose();
    taxFocusNode.dispose();
    accountFocusNode.dispose();
    passwordFocusNode.dispose();
  }
}
