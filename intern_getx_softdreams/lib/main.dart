import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inter_test/model/product.dart';
import 'package:inter_test/presentations/screens/home/home_screen.dart';
import 'package:inter_test/presentations/screens/login/login_screen.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ProductAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      getPages: [
        GetPage(name: '/page-three', page: () => const HomeScreen()),
      ],
    );
  }
}
