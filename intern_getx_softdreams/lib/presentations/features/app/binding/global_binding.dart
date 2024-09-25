import 'package:get/get.dart';
import 'package:inter_test/presentations/features/add_product/repository/add_product_repo.dart';
import 'package:inter_test/service/hive_service_master.dart';

import '../../../../service/api_service.dart';
import '../../detail/repository/detail_repo.dart';
import '../../home/repository/list_product_repo.dart';
import '../../login/repository/login_repo.dart';


class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiServices>(() => ApiServices(), fenix: true);
    Get.lazyPut<HiveService>(() => HiveService(), fenix: true);
    Get.lazyPut<LoginRepo>(() => LoginRepo(), fenix: true);
    Get.lazyPut<DetailProductRepo>(() => DetailProductRepo(), fenix: true);
    Get.lazyPut<ListProductRepo>(() => ListProductRepo(), fenix: true);
    Get.lazyPut<AddProductRepo>(() => AddProductRepo(), fenix: true);
  }
}
