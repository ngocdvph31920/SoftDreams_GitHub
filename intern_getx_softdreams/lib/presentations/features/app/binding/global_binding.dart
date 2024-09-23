import 'package:get/get.dart';
import 'package:inter_test/service/hive_service_master.dart';

import '../../../../service/api_service.dart';
import '../../login/repository/login_repo.dart';


class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiServices>(() => ApiServices(), fenix: true);
    Get.lazyPut<HiveService>(() => HiveService(), fenix: true);
    Get.lazyPut<LoginRepo>(() => LoginRepo(), fenix: true);

  }
}
