import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_test/model/product.dart';
import 'package:inter_test/presentations/popup/loading_popup.dart';
import 'detail_controller.dart';

class DetailScreen extends StatefulWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final DetailController _detailController = Get.put(DetailController());

  final TextEditingController nameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController quantityController = TextEditingController();

  final TextEditingController coverUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.product.name;
    priceController.text = widget.product.price.toString();
    quantityController.text = widget.product.quantity.toString();
    coverUrlController.text = widget.product.cover;

    _detailController.status.listen((status) {
      if (status == DetailStatus.success) {
        LoadingPopup.hideLoadingDialog(context);
        Get.back();
      } else if (status == DetailStatus.inProcess) {
        LoadingPopup.showLoadingDialog(context);
      } else if (status == DetailStatus.initial) {
        LoadingPopup.hideLoadingDialog(context);
        Get.back();
      } else if (status == DetailStatus.failure) {
        LoadingPopup.hideLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("error server"),
          ),
        );
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Detail",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: CachedNetworkImage(
                imageUrl: widget.product.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Giá: \$${widget.product.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Số Lượng: ${widget.product.quantity}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Chỉnh sửa sản phẩm',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF24E1E),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: coverUrlController,
              decoration: InputDecoration(
                labelText: 'Cover URL',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _detailController.updateProduct(
                      productId: widget.product.id,
                      name: nameController.text,
                      price: int.parse(priceController.text),
                      quantity: int.parse(quantityController.text),
                      coverUrl: coverUrlController.text,
                    );
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor: const Color(0xFFF24E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Sửa',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Xác nhận'),
                          content: const Text(
                              'Bạn có chắc chắn muốn xóa sản phẩm này không?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () {
                                _detailController
                                    .deleteProductFromList(widget.product);
                                Get.back();
                                Get.back();
                              },
                              child: const Text('Xóa'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor: const Color(0xFFF24E1E), // Màu cam
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Xóa Sản Phẩm',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
}
