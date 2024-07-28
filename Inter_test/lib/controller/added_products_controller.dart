import 'package:get/get.dart';
import 'package:inter_test/model/product.dart';

class AddedProductsController extends GetxController {
  var addedProducts = <Product>[].obs;
  // final addedProductsController = Get.find<AddedProductsController>();
  RxDouble totalPrice = 0.0.obs;


  void addProduct(Product product) {
    addedProducts.add(product);
    totalPriceProduct();
  }
  void removeProduct(Product product) {
    addedProducts.remove(product);
    totalPrice.value =0.0;
    totalPriceProduct();
  }
   void totalPriceProduct(){

     for (Product product in addedProducts) {
       totalPrice.value += product.price;
     }
     totalPrice.value = double.parse(totalPrice.toStringAsFixed(2));
   }
}
