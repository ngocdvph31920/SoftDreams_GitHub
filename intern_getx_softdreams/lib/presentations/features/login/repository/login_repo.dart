import 'package:get/get.dart';
import '../../../../service/api_service.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';

class LoginRepo {
  final ApiServices apiServices = Get.find();

  Future<LoginResponse> login(LoginRequest request) async {
    final body = request.toJson();
    final response = await apiServices.dio.post('/login', data: body);
    return LoginResponse.fromJson(response.data);
  }
}