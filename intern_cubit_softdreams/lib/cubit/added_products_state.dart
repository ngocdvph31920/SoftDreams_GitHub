part of 'added_products_cubit.dart';

class AddedProductsState {
  final List<Product> addedProducts;

  AddedProductsState({this.addedProducts = const []});

  double get totalPrice => addedProducts.fold(0, (total, product) => total + product.price);
}
