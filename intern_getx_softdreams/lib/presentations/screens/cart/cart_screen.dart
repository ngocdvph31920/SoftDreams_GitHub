import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_test/presentations/popup/loading_popup.dart';
import 'package:inter_test/presentations/screens/home/home_controller.dart';
import 'cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _homeController = Get.find<HomeController>();
  final _cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    _cartController.fetchTotalPriceProduct();

    _cartController.statusDelete.listen((status) {
      if (status == StatusDelete.deleteSuccess) {
        LoadingPopup.hideLoadingDialog(context);
        _homeController.fetchProducts();
        _cartController.fetchTotalPriceProduct();
      } else if (status == StatusDelete.inProcess) {
        LoadingPopup.showLoadingDialog(context);
      } else if (status == StatusDelete.initial) {
        LoadingPopup.hideLoadingDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Added Products',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: _homeController.listProductsCart.length,
                itemBuilder: (context, index) {
                  final product = _homeController.listProductsCart[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: ListTile(
                      leading: SizedBox(
                        width: 60,
                        height: 100,
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
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Giá: \$${product.price}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Số Lượng: ${product.quantity}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () {
                          _cartController.removeProductInCart(product);
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() {
            return Container(
              alignment: Alignment.center,
              height: 60,
              width: double.infinity,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Total: \$${_cartController.totalPrice}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
