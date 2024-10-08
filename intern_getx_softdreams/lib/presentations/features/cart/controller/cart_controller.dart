import 'package:get/get.dart';
import 'package:inter_test/presentations/popup/loading_popup.dart';
import 'package:inter_test/presentations/features/home/controller/home_controller.dart';
import 'package:inter_test/service/hive_service_master.dart';

enum StatusDelete {
  initial,
  inProcess,
  deleteSuccess,
}

class CartController extends GetxController {
  RxDouble totalPrice = 0.0.obs;
  var statusDelete = StatusDelete.initial.obs;
  final homeController = Get.find<HomeController>();
  final HiveService hiveService = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchTotalPriceProduct();

    final context = Get.context;

    if (context == null) return;

    statusDelete.listen((status) {
      if (status == StatusDelete.deleteSuccess) {
        LoadingPopup.hideLoadingDialog(context);
        homeController.fetchProducts();
        fetchTotalPriceProduct();
      } else if (status == StatusDelete.inProcess) {
        LoadingPopup.showLoadingDialog(context);
      } else if (status == StatusDelete.initial) {
        LoadingPopup.hideLoadingDialog(context);
      }
    });
  }

  void removeFromCart(int productId) async {
    await HiveService.deleteItem(productId);
    homeController.fetchListProductCart();
    fetchTotalPriceProduct();
  }

  Future<void> fetchTotalPriceProduct() async {
    statusDelete.value = StatusDelete.initial;

    totalPrice.value = homeController.listProductCart
        .fold(0.0, (sum, product) => sum + product.price);
    totalPrice.value = double.parse(totalPrice.toStringAsFixed(2));
  }
}
