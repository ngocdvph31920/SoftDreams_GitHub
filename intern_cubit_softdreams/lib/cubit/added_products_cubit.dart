import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/product.dart';

part 'added_products_state.dart';

class AddedProductsCubit extends Cubit<AddedProductsState> {
  AddedProductsCubit() : super(AddedProductsState());

  void addProduct(Product product) {
    final updatedProducts = List<Product>.from(state.addedProducts)
      ..add(product);
    emit(AddedProductsState(addedProducts: updatedProducts));
  }

  void removeProduct(Product product) {
    final updatedProducts = List<Product>.from(state.addedProducts)
      ..remove(product);
    emit(AddedProductsState(addedProducts: updatedProducts));
  }
}
