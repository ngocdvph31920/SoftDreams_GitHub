import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../../../service/hive_service_master.dart';
import '../../../popup/loading_popup.dart';
import '../model/login_request.dart';
import '../repository/login_repo.dart';

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
  final LoginRepo loginRepo = Get.find();
  final HiveService hiveService = Get.find();

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

    LoginRequest loginRequest = LoginRequest(
      taxCode: taxCode,
      userName: userName,
      password: passWord,
    );

    try {
      statusLogin.value = StatusLogin.inProcess;
      final loginResponse = await loginRepo.login(loginRequest);
      if (loginResponse.success) {

        await HiveService.setLoggedIn(true);
        if (loginResponse.token != null) {
          await hiveService.saveToken(loginResponse.token!);
        }
        hiveService.saveTaxCode('$taxCode');
        hiveService.saveAccount(userName);
        hiveService.savePassword(passWord);
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
        Get.snackbar(
          'Đăng nhập thành công',
          'Bạn đã đăng nhập thành công.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed('/home');
      } else if (status == StatusLogin.loginFailure) {
        LoadingPopup.hideLoadingDialog(buildContext);
        Get.snackbar(
          'Đăng nhập thất bại',
          'Tên đăng nhập hoặc mật khẩu không chính xác.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
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
