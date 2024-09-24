import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          controller: controller.taxController,
                          focusNode: controller.taxFocusNode,
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
                                color: controller.taxFocusNode.hasFocus
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: GestureDetector(
                                onTap: () {
                                  controller.taxController.clear();
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
                          onChanged: (value) {
                            controller.formKey.currentState?.validate();
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(controller.accountFocusNode);
                          },
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
                        const Text(
                          'Tài khoản',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF000000),
                          ),
                        ),
                        TextFormField(
                          controller: controller.accountController,
                          focusNode: controller.accountFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Tài khoản',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller.accountFocusNode.hasFocus
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
                          onChanged: (value) {
                            controller.formKey.currentState?.validate();
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(controller.passwordFocusNode);
                          },
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
                          controller: controller.passwordController,
                          obscureText: controller.obscureText,
                          focusNode: controller.passwordFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Mật khẩu',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller.passwordFocusNode.hasFocus
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: GestureDetector(
                                onTap: () {
                                  // setState(() {
                                  //   _obscureText = !_obscureText;
                                  // });

                                  controller.obscureText =
                                      !controller.obscureText;
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
                          onChanged: (value) {
                            controller.formKey.currentState?.validate();
                          },
                          onFieldSubmitted: (_) {
                            controller.submitForm();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mật khẩu không được để trống';
                            }
                            if (value.length < 6 || value.length > 50) {
                              return 'Mật khẩu phải có độ dài từ 6 đến 50 ký tự';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: controller.submitForm,
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
