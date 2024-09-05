import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:inter_test/presentations/popup/loading_popup.dart';
import 'package:inter_test/presentations/screens/home/home_screen.dart';
import 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = Get.put(LoginController());

  bool _obscureText = true;
  final _taxController = TextEditingController();
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // FocusNodes
  final _taxFocusNode = FocusNode();
  final _accountFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();


    loginController.authentication();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    loginController.statusLogin.listen((status) {
      if (status == StatusLogin.loginSuccess) {
        LoadingPopup.hideLoadingDialog(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else if (status == StatusLogin.loginFailure) {
        LoadingPopup.hideLoadingDialog(context);
      } else if (status == StatusLogin.inProcess) {
        LoadingPopup.showLoadingDialog(context);
      } else if (status == StatusLogin.initial) {
        LoadingPopup.hideLoadingDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _taxController.dispose();
    _accountController.dispose();
    _passwordController.dispose();
    _taxFocusNode.dispose();
    _accountFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 158,
                            height: 37,
                            child: Image.asset(
                              'assets/images/Easy.png',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Mã số thuế',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF000000),
                        ),
                      ),
                      TextFormField(
                        controller: _taxController,
                        focusNode: _taxFocusNode,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: 'Mã số thuế',
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _taxFocusNode.hasFocus
                                  ? Colors.orange
                                  : Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0XFFF24E1E),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _taxController.clear();
                                });
                              },
                              child: SvgPicture.asset(
                                'assets/icons/delete1.svg',
                                width: 24,
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                        style: const TextStyle(fontSize: 17),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mã số thuế';
                          }
                          if (value.length != 10) {
                            return 'Mã số thuế phải có độ dài 10 số';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      // Error message for Tax Number
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          _taxController.text.isEmpty
                              ? ''
                              : _taxController.text.length != 10
                                  ? 'Mã số thuế phải có độ dài 10 số'
                                  : '',
                          style: const TextStyle(color: Color(0xFFF24E1E)),
                        ),
                      ),
                      const Text(
                        'Tài khoản',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF000000),
                        ),
                      ),
                      TextFormField(
                        controller: _accountController,
                        focusNode: _accountFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Tài khoản',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _accountFocusNode.hasFocus
                                  ? Colors.orange
                                  : Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0XFFF24E1E),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        style: const TextStyle(fontSize: 17),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tài khoản không được để trống';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Mật khẩu',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF000000),
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Mật khẩu',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _passwordFocusNode.hasFocus
                                  ? Colors.orange
                                  : Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0XFFF24E1E),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: SvgPicture.asset(
                                'assets/icons/eye.svg',
                                width: 24,
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                        style: const TextStyle(fontSize: 17),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mật khẩu không được để trống';
                          }
                          if (value.length < 6 || value.length > 50) {
                            return 'Mật khẩu phải từ 8 đến 50 ký tự';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF24E1E),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                loginController.login(
                                  taxCode: int.parse(_taxController.text),
                                  userName: _accountController.text.trim(),
                                  passWord: _passwordController.text.trim(),
                                );
                                ever(loginController.statusLogin, (status) {
                                  if (status == StatusLogin.loginSuccess) {
                                    Get.snackbar(
                                      'Đăng nhập thành công',
                                      'Bạn đã đăng nhập thành công.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                  } else if (status ==
                                      StatusLogin.loginFailure) {
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
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF24E1E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Center(
                              child: Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      socialMediaButton(
                          'Trợ giúp', 'assets/icons/headphone.svg'),
                      Expanded(child: Container()),
                      socialMediaButton('Group', 'assets/icons/face.svg'),
                      Expanded(child: Container()),
                      socialMediaButton('Tra cứu', 'assets/icons/seach.svg'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget socialMediaButton(String name, String assetPath) {
    return Container(
      width: 109,
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0XFFFFFFFF),
        border: Border.all(
          color: const Color(0xFFEBECED),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              assetPath,
              width: 24,
            ),
          ),
          Flexible(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0XFF000000),
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
