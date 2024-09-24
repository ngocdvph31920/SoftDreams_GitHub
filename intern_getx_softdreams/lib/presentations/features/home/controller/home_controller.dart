import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../model/product.dart';
import '../../../../service/hive_service_master.dart';
import '../model/list_product_request.dart';
import '../repository/list_product_repo.dart';

class HomeController extends GetxController {
  final ListProductRepo homeRepo = Get.find();
  final isLoading = false.obs;
  final productList = <Product>[].obs;
  int currentPage = 1;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 400) {
      loadMore();
    }
  }

  Future<void> logout() async {
    await HiveService.setLoggedIn(false);
    Get.offAllNamed('/login');
  }

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      int tempPage = isLoadMore ? currentPage + 1 : 1;
      final response = await homeRepo.getListProduct(
        ListProductRequest(page: tempPage, limit: 10),
      );

      if (response.success && response.data.isNotEmpty) {
        if (isLoadMore) {
          productList.addAll(response.data);
          currentPage = tempPage;
        } else {
          productList.assignAll(response.data);
          currentPage = 1;
        }
      }
    } on DioException catch (e) {
      print("Lỗi: ${e.response?.statusCode} - ${e.response?.statusMessage}");
    } catch (e) {
      print("Đã xảy ra lỗi: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    await fetchProducts(isLoadMore: true);
  }

  Future<void> onRefresh() async {
    await fetchProducts();
  }

  void addToCart(Product product) {
    HiveService.addToCart(product);
    productList.refresh();
  }

  Future<void> navigateToCart() async {
    final result = await Get.toNamed('/cart');
    if (result != null && result == 'back') {
      onRefresh();
    }
  }

  void showLogoutConfirmationDialog() {
    final BuildContext? context = Get.context;
    if (context == null) return;

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
                logout();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addProductToCart(Product product) async {
    Product? existingProduct = productList.firstWhereOrNull(
      (p) => p.id == product.id,
    );

    if (existingProduct != null) return;

    final listProductCart = await HiveService.getProducts();
    listProductCart.add(product);

    await HiveService.saveProducts(listProductCart);

    fetchProducts();
  }
}
