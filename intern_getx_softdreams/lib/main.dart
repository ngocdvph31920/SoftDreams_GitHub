import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inter_test/model/product.dart';
import 'package:inter_test/presentations/features/add_product/binding/add_product_binding.dart';
import 'package:inter_test/presentations/features/add_product/screen/add_product_screen.dart';
import 'package:inter_test/presentations/features/cart/screen/cart_screen.dart';
import 'package:inter_test/presentations/features/detail/binding/detail_binding.dart';
import 'package:inter_test/presentations/features/detail/screen/detail_screen.dart';
import 'package:inter_test/presentations/features/home/binding/home_binding.dart';
import 'package:inter_test/presentations/features/home/screen/home_screen.dart';
import 'package:inter_test/presentations/features/login/screen/login_screen.dart';
import 'package:inter_test/presentations/features/splash_screen.dart';

import 'presentations/features/cart/binding/cart_binding.dart';
import 'presentations/features/login/binding/login_binding.dart';

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
      home: const SplashScreen(),
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          binding: LoginBinding(),
        ),
        GetPage(
            name: '/home',
            page: () => const HomeScreen(),
            binding: HomeBinding()),
        GetPage(
            name: '/detail',
            page: () => const DetailScreen(),
            binding: DetailBinding()),
        GetPage(
          name: '/cart',
          page: () => const CartScreen(),
          binding: CartBinding(),
        ),
        GetPage(
          name: '/add',
          page: () => const AddProductScreen(),
          binding: AddProductBinding(),
        ),
      ],
    );
  }
}
