import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SharedPreferences.getInstance());
    Get.lazyPut<SignUpController>(
      () => SignUpController(),
    );
  }
}
