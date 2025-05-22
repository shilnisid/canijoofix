import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/supplier_controller.dart';

class SupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SharedPreferences.getInstance());
    Get.lazyPut<SupplierController>(
      () => SupplierController(),
    );
  }
}
