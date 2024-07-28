import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/added_products_controller.dart';

class AddedProductsScreen extends StatelessWidget {
  const AddedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addedProductsController = Get.find<AddedProductsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Added Products'),
      ),
      body: Obx(() {

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: addedProductsController.addedProducts.length,
                itemBuilder: (context, index) {
                  final product = addedProductsController.addedProducts[index];
                  return ListTile(
                    leading: Image.asset(
                      product.image,
                      width: 40,
                      height: 40,
                    ),
                    title: Text(
                      product.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever_outlined,
                          color: Colors.black),
                      onPressed: () {
                        addedProductsController.removeProduct(product);
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 100,
              width: double.infinity,
              color: Colors.grey,
              child: Text(
                'Total: ${addedProductsController.totalPrice.value}\$',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
