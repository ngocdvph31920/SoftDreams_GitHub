import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_test/service/hive_service_master.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigatorNextScreen();
  }

  void navigatorNextScreen() async {
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(HiveService.isLoggedIn ? '/home' :'/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
