import 'package:dio/dio.dart';
import 'package:inter_test/service/api_service.dart';

class ApiServices {
  final Dio dio = Dio(
    BaseOptions(
        baseUrl: 'https://training-api-unrp.onrender.com',
        validateStatus: (status) {
          return status != null && status < 500;
        }),
  )..interceptors.add(HeaderInterceptor());
}

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(
      {
        'Content-Type': 'application/json',
        //'Authorization': HiveService.getToken(),
      },
    );
    super.onRequest(options, handler);
  }
}
