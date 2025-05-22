import '../../../../routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ResetPasswordController extends GetxController {

  TextEditingController emailC = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  void resetPassword(String email) async {
    if (email != "" && GetUtils.isEmail(email)) {
      try {
        await auth.sendPasswordResetEmail(email: email);
        Get.defaultDialog(
            title: "Berhasil",
            middleText: "Reset password telah terkirim ke email $email.",
            onConfirm: () {
              Get.back(); //close dialog    
              Get.toNamed(Routes.LOGIN); //back to login
            },   
            textConfirm: "Okay");
            
      } catch (e) {
        Get.defaultDialog(
            title: "Terjadi kesalahan",
            middleText: "Tidak dapat mengirimkan reset password");
      }
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    super.onClose();
  }
}
