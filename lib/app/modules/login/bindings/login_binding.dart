import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SharedPreferences.getInstance());
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
