import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trang Chủ',
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
                  await Get.toNamed('/cart');
                  controller.fetchProducts();
                },
              ),
              Positioned(
                top: 0,
                right: 3,
                child: Obx(() => Text(
                      '${controller.listProductCart.length}',
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
                    controller: controller.scrollController,
                    itemCount: controller.productList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.productList.length) {
                        return Obx(() => controller.isLoading.value
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox());
                      }
                      final product = controller.productList[index];
                      final isAdded = controller.listProductCart
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
                                          controller.addToCart(product);
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
                            await Get.toNamed(
                              '/detail',
                              arguments: product,
                            );
                            controller.fetchProducts();
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
                            await Get.toNamed('/add');
                            controller.fetchProducts();
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
                          onPressed: controller.showLogoutDialog,
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
