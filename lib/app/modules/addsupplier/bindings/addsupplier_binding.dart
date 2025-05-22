import 'package:get/get.dart';

import '../controllers/addsupplier_controller.dart';

class AddsupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddsupplierController>(
      () => AddsupplierController(),
    );
  }
}
