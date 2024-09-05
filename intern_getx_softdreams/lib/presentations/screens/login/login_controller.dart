import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

enum StatusLogin {
  initial,
  inProcess,
  loginSuccess,
  loginFailure,
}

class LoginController extends GetxController {
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
}
