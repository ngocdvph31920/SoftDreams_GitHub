import 'package:get/get.dart';
import '../../../../model/product.dart';
import '../../../../service/api_service.dart';
import '../model/detail_product_response.dart';

class DetailProductRepo {
  final ApiServices apiServices = Get.find();

  Future<DetailProductResponse> fetchDetailProduct(int productId) async {
    final response = await apiServices.dio.get('/products/$productId');
    return DetailProductResponse.fromJson(response.data);
  }

  Future<DetailProductResponse> deleteProduct(int productId) async {
    final response = await apiServices.dio.delete('/products/$productId');
    print('NgocDV 88888  response = $response');
    return DetailProductResponse.fromJson(response.data);
  }

  Future<DetailProductResponse> updateProducts(Product product) async {
    final body = product.toJson();
    final response =
    await apiServices.dio.put('/products/${product.id}', data: body);
    return DetailProductResponse.fromJson(response.data);
  }

  Future<DetailProductResponse> createProduct(Product product) async {
    final body = product.toJson();
    final response = await apiServices.dio.post('/products', data: body);
    return DetailProductResponse.fromJson(response.data);
  }
}
