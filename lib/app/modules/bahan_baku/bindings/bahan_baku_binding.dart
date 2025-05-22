import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/bahan_baku_controller.dart';

class BahanBakuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SharedPreferences.getInstance());
    Get.lazyPut<BahanBakuController>(
      () => BahanBakuController(),
    );
  }
}
