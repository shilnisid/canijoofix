import 'package:get/get.dart';

import '../controllers/addbahan_baku_controller.dart';

class AddbahanBakuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddbahanBakuController>(
      () => AddbahanBakuController(),
    );
  }
}
