import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:inter_test/presentations/popup/loading_popup.dart';
import 'package:inter_test/presentations/screens/add_product/add_product_screen.dart';
import 'package:inter_test/presentations/screens/cart/cart_screen.dart';

import 'package:inter_test/presentations/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inter_test/presentations/screens/detail/detail_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = Get.put(HomeController());
    _homeController.fetchProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeController.statusGetList.listen((status) {
      if (status == StatusGetList.success) {
        LoadingPopup.hideLoadingDialog(context);
      } else if (status == StatusGetList.failure) {
        LoadingPopup.hideLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("GetLis failure"),
          ),
        );
      } else if (status == StatusGetList.inProcess) {
        LoadingPopup.showLoadingDialog(context);
      } else if (status == StatusGetList.initial) {
        LoadingPopup.hideLoadingDialog(context);
      }
    });
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    Get.offAll(() => const LoginScreen());
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Đăng xuất'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/cart.svg',
                  width: 24,
                  height: 24,
                  fit: BoxFit.fill,
                ),
                onPressed: () async {
                  await Get.to(
                    () => const CartScreen(),
                  );
                  _homeController.fetchProducts();
                },
              ),
              Positioned(
                top: 0,
                right: 3,
                child: Obx(() => Text(
                      '${_homeController.listProductsCart.length}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    )),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Obx(() => Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemCount: _homeController.listProducts.length,
                    itemBuilder: (context, index) {
                      final product = _homeController.listProducts[index];
                      final isAdded = _homeController.listProductsCart
                          .any((p) => p.id == product.id);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: SizedBox(
                            width: 70,
                            height: 130,
                            child: CachedNetworkImage(
                              imageUrl: product.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Giá: \$${product.price}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Số Lượng: ${product.quantity}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 30,
                                child: isAdded
                                    ? const IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                          Icons.check,
                                          color: Colors.black,
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: () {
                                          _homeController
                                              .addProductToCart(product);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text('Add'),
                                      ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            await Get.to(() => DetailScreen(product: product));
                            _homeController.fetchProducts();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.5),
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Get.to(
                              () => const AddProductScreen(),
                            );
                            _homeController.fetchProducts();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            'Thêm mới',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _showLogoutConfirmationDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            'Đăng xuất',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
