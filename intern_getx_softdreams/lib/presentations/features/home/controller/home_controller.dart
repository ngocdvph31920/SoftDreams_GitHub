import 'package:dio/dio.dart';
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
  final listProductCart = <Product>[].obs;
  int currentPage = 1;
  bool hasMoreProducts = true;
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
    scrollController.dispose();
    super.onClose();
  }

  void fetchListProductCart() {
    listProductCart.value = HiveService.getCartItem();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoading.value &&
        hasMoreProducts) {
      loadMore();
    }
  }

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      int tempPage = isLoadMore ? currentPage + 1 : 1;
      final response = await homeRepo.getListProduct(
        ListProductRequest(page: tempPage, limit: 10),
      );

      if (response.success) {
        if (isLoadMore) {
          if (response.data.isNotEmpty) {
            productList.addAll(response.data);
            currentPage = tempPage;
          } else {
            hasMoreProducts = false;
          }
        } else {
          productList.assignAll(response.data);
          currentPage = 1;
          hasMoreProducts = response.data.isNotEmpty;
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
    hasMoreProducts = true;
    await fetchProducts();
  }

  void addToCart(Product product) {
    HiveService.addToCart(product);
    listProductCart.refresh();
    fetchListProductCart();
  }

  Future<void> navigateToCart() async {
    final result = await Get.toNamed('/cart');
    if (result != null && result == 'back') {
      onRefresh();
    }
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: 'Đăng xuất',
      content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          logout();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        child: const Text('Đăng xuất'),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          'Hủy',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Future<void> logout() async {
    await HiveService.setLoggedIn(false);
    Get.offAllNamed('/login');
  }

// Future<void> addProductToCart(Product product) async {
//   Product? existingProduct = productList.firstWhereOrNull(
//         (p) => p.id == product.id,
//   );
//
//   if (existingProduct != null) return;
//
//   final listProductCart = await HiveService.getProducts();
//   listProductCart.add(product);
//
//   await HiveService.saveProducts(listProductCart);
//
//   fetchProducts();
// }
}
