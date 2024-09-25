import 'package:get/get.dart';
import '../../../../model/product.dart';
import '../../../../service/api_service.dart';
import '../../detail/model/detail_product_response.dart';

class AddProductRepo {
  final ApiServices apiServices = Get.find();

  Future<DetailProductResponse> createProduct(Product product) async {
    final body = product.toJson();
    final response = await apiServices.dio.post('/products', data: body);
    return DetailProductResponse.fromJson(response.data);
  }
}
